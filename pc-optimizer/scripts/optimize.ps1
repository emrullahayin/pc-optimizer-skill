# pc-optimizer: reversible Windows performance settings.
# Run from an ADMINISTRATOR PowerShell / Terminal:
#   Apply  : powershell -ExecutionPolicy Bypass -File .\optimize.ps1
#   Preview: powershell -ExecutionPolicy Bypass -File .\optimize.ps1 -DryRun
#   Undo   : powershell -ExecutionPolicy Bypass -File .\optimize.ps1 -Undo
[CmdletBinding()]
param(
  [switch]$Undo,
  [switch]$DryRun,
  [switch]$SkipVisualEffects,
  [switch]$SkipHibernate,
  [switch]$SkipCleanup
)

$ErrorActionPreference = 'Stop'
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin -and -not $DryRun) { Write-Host 'Run this script as ADMINISTRATOR.' -ForegroundColor Red; exit 1 }

$backupDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PcOptimizerBackup'
$stateFile = Join-Path $backupDir 'state.json'
$regKeys = @(
  'HKCU\System\GameConfigStore',
  'HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR',
  'HKCU\Software\Microsoft\GameBar',
  'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects',
  'HKCU\Control Panel\Desktop',
  'HKCU\Control Panel\Mouse',
  'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power'
)
$ULTIMATE = 'e9a42b02-d5df-448d-aa00-03f14749eb61'
$HIGHPERF = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
$isLaptop = @(Get-CimInstance Win32_Battery).Count -gt 0

function Step($n, $msg) { Write-Host "[$n] $msg" -ForegroundColor Green }
function Do-It([scriptblock]$Action, [string]$Description) {
  if ($DryRun) { Write-Host "  would: $Description" -ForegroundColor Yellow } else { & $Action }
}
function Set-Dword($path, $name, $val) {
  Do-It { if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
          New-ItemProperty -Path $path -Name $name -Value $val -PropertyType DWord -Force | Out-Null } "set $path\$name = $val"
}
function Set-Str($path, $name, $val) {
  Do-It { Set-ItemProperty -Path $path -Name $name -Value $val } "set $path\$name = $val"
}
function Get-Guid($text) { if ($text -match '([0-9a-fA-F]{8}-[0-9a-fA-F-]{27})') { $Matches[1] } }
function Plan-Exists($guid) { [bool](powercfg /list | Select-String -SimpleMatch $guid) }

# ------------------------------------------------------------------ UNDO
if ($Undo) {
  if (-not (Test-Path $stateFile)) { Write-Host "No backup found at $backupDir" -ForegroundColor Red; exit 1 }
  $state = Get-Content $stateFile -Raw | ConvertFrom-Json
  Get-ChildItem $backupDir -Filter 'key*.reg' | ForEach-Object { reg import $_.FullName 2>$null | Out-Null; Write-Host "restored $($_.Name)" }
  if ($state.PreviousPlan -and (Plan-Exists $state.PreviousPlan)) { powercfg /setactive $state.PreviousPlan }
  if ($state.CreatedPlan -and $state.CreatedPlan -ne $state.PreviousPlan -and (Plan-Exists $state.CreatedPlan)) { powercfg /delete $state.CreatedPlan | Out-Null }
  if ($state.HibernateWasOn) { powercfg /hibernate on }
  Write-Host 'Undo complete. Please restart the PC.' -ForegroundColor Cyan
  exit 0
}

# ------------------------------------------------------------------ BACKUP
if (-not $DryRun) {
  New-Item -ItemType Directory -Force $backupDir | Out-Null
  $first = -not (Test-Path $stateFile)
  if ($first) {
    $i = 0
    foreach ($k in $regKeys) { $i++; reg export $k (Join-Path $backupDir "key$i.reg") /y 2>$null | Out-Null }
    $state = [ordered]@{
      Created        = (Get-Date).ToString('s')
      PreviousPlan   = Get-Guid (powercfg /getactivescheme)
      HibernateWasOn = Test-Path "$env:SystemDrive\hiberfil.sys"
      CreatedPlan    = $null
    }
    $state | ConvertTo-Json | Set-Content $stateFile -Encoding UTF8
  } else {
    $state = Get-Content $stateFile -Raw | ConvertFrom-Json
    Write-Host "Existing backup kept (from $($state.Created)); Undo returns to that original state." -ForegroundColor Yellow
  }
  try { Checkpoint-Computer -Description 'pc-optimizer: before changes' -RestorePointType MODIFY_SETTINGS }
  catch { Write-Host 'Restore point skipped (Windows allows one per 24h, or System Protection is off). Continuing.' -ForegroundColor Yellow }
  Write-Host "Backup: $backupDir" -ForegroundColor Cyan
}

# ------------------------------------------------------------------ 1. POWER
$guid = $null
$active = Get-Guid (powercfg /getactivescheme)
# Reuse the active plan if it is already a performance/custom plan (not Balanced or Power saver)
if ($active -and $active -notin @('381b4222-f694-41f0-9685-ff5bb260df2e','a1841308-3541-4fab-bc81-f71556f20b4a')) { $guid = $active }
if (-not $guid -and $state -and $state.CreatedPlan -and (Plan-Exists $state.CreatedPlan)) { $guid = $state.CreatedPlan }
if (-not $guid -and (Plan-Exists $ULTIMATE)) { $guid = $ULTIMATE }
if (-not $guid -and -not $DryRun) {
  $guid = Get-Guid (powercfg -duplicatescheme $ULTIMATE 2>$null)
  if ($guid) { $state.CreatedPlan = $guid; $state | ConvertTo-Json | Set-Content $stateFile -Encoding UTF8 }
}
if (-not $guid) { $guid = $HIGHPERF }  # e.g. Modern Standby systems that block Ultimate

Do-It {
  powercfg /setactive $guid
  powercfg /setacvalueindex $guid SUB_PCIEXPRESS ASPM 0
  powercfg /setacvalueindex $guid 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0
  powercfg /change monitor-timeout-ac 15
  powercfg /change standby-timeout-ac 0
  powercfg /setactive $guid
} "activate performance power plan, PCIe ASPM off, USB selective suspend off (AC only)"
Step 1 "Power plan: performance (AC). Battery settings untouched$(if ($isLaptop) { ' - laptop detected' })."

# ------------------------------------------------------------------ 2. GAMING
Set-Dword 'HKCU:\Software\Microsoft\GameBar' 'AutoGameModeEnabled' 1
Set-Dword 'HKCU:\Software\Microsoft\GameBar' 'AllowAutoGameMode' 1
Set-Dword 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0
Set-Dword 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 0
Set-Dword 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'HistoricalCaptureEnabled' 0
Step 2 'Game Mode on, Xbox background recording off.'

# ------------------------------------------------------------------ 3. VISUAL EFFECTS
if (-not $SkipVisualEffects) {
  Set-Dword 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' 'VisualFXSetting' 3
  Do-It { Set-ItemProperty 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00)) -Type Binary } 'visual effects mask = best performance'
  Set-Str 'HKCU:\Control Panel\Desktop' 'FontSmoothing' '2'
  Set-Str 'HKCU:\Control Panel\Desktop' 'MenuShowDelay' '0'
  Step 3 'Visual effects: performance (font smoothing kept).'
}

# ------------------------------------------------------------------ 4. MOUSE
Set-Str 'HKCU:\Control Panel\Mouse' 'MouseSpeed' '0'
Set-Str 'HKCU:\Control Panel\Mouse' 'MouseThreshold1' '0'
Set-Str 'HKCU:\Control Panel\Mouse' 'MouseThreshold2' '0'
Step 4 'Mouse acceleration off.'

# ------------------------------------------------------------------ 5. FAST STARTUP / HIBERNATE
if (-not $SkipHibernate -and -not $isLaptop) {
  Set-Dword 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' 'HiberbootEnabled' 0
  Do-It { powercfg /hibernate off } 'hibernate off (removes hiberfil.sys)'
  Step 5 'Fast Startup and hibernation off.'
} elseif ($isLaptop) { Write-Host '[5] Laptop: Fast Startup/hibernation left unchanged.' -ForegroundColor Yellow }

# ------------------------------------------------------------------ 6. STORAGE
if (-not $SkipCleanup) {
  Do-It {
    $sysVol = (Get-PhysicalDisk | Where-Object MediaType -eq 'SSD')
    if ($sysVol) { Optimize-Volume -DriveLetter ($env:SystemDrive.TrimEnd(':')) -ReTrim -ErrorAction SilentlyContinue | Out-Null }
    foreach ($t in @($env:TEMP, "$env:SystemRoot\Temp")) {
      Get-ChildItem $t -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
  } 'SSD ReTrim on system drive, clear temp folders'
  Step 6 'SSD TRIM done, temp files cleared.'
}

Write-Host "`nDone. RESTART the PC to apply everything." -ForegroundColor Cyan
Write-Host "Undo any time: powershell -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Undo" -ForegroundColor Cyan
