# pc-optimizer: read-only system diagnosis. Changes nothing. No admin required.
$ErrorActionPreference = 'SilentlyContinue'

function Get-RegValue($Path, $Name) {
  try { (Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop).$Name } catch { '<not set>' }
}
function Section($t) { Write-Host "`n== $t ==" -ForegroundColor Cyan }

Section 'Hardware'
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$ram = Get-CimInstance Win32_PhysicalMemory
$cs  = Get-CimInstance Win32_ComputerSystem
$bb  = Get-CimInstance Win32_BaseBoard
$bat = @(Get-CimInstance Win32_Battery).Count
"CPU        : $($cpu.Name.Trim()) ($($cpu.NumberOfCores)C/$($cpu.NumberOfLogicalProcessors)T)"
"RAM        : $([math]::Round(($ram | Measure-Object Capacity -Sum).Sum/1GB)) GB, $($ram.Count) stick(s), configured $((($ram.ConfiguredClockSpeed) | Sort-Object -Unique) -join '/') MT/s, rated $((($ram.Speed) | Sort-Object -Unique) -join '/') MT/s"
"Board      : $($bb.Manufacturer) $($bb.Product) | BIOS $((Get-CimInstance Win32_BIOS).SMBIOSBIOSVersion)"
"Form factor: $(if ($bat -gt 0) { 'LAPTOP (battery present)' } else { 'Desktop' })"

Section 'GPU / Display'
Get-CimInstance Win32_VideoController | ForEach-Object {
  "GPU        : $($_.Name) | driver $($_.DriverVersion) ($(([datetime]$_.DriverDate).ToString('yyyy-MM-dd')))"
  if ($_.CurrentHorizontalResolution) { "Display    : $($_.CurrentHorizontalResolution)x$($_.CurrentVerticalResolution) @ $($_.CurrentRefreshRate) Hz" }
}
$modes = Get-CimInstance -Namespace root\wmi WmiMonitorListedSupportedSourceModes |
  ForEach-Object { $_.MonitorSourceModes | ForEach-Object { [math]::Round($_.VerticalRefreshRateNumerator / [math]::Max(1,$_.VerticalRefreshRateDenominator)) } } |
  Sort-Object -Unique -Descending | Select-Object -First 4
if ($modes) { "EDID modes : $($modes -join ', ') Hz (EDID list may omit high-refresh modes; trust Windows display settings)" }

Section 'Storage'
Get-PhysicalDisk | ForEach-Object { "Disk       : $($_.FriendlyName) | $($_.MediaType) | $($_.BusType) | $([math]::Round($_.Size/1GB)) GB" }
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null -and ($_.Used + $_.Free) -gt 0 } | ForEach-Object {
  "Volume $($_.Name):  : {0:N0} GB free of {1:N0} GB" -f ($_.Free/1GB), (($_.Used + $_.Free)/1GB)
}

Section 'Power'
"Active plan: $((powercfg /getactivescheme) -replace '^.*?:\s*','')"
"Fast Startup (HiberbootEnabled): $(Get-RegValue 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' HiberbootEnabled)"
"hiberfil.sys present: $(Test-Path "$env:SystemDrive\hiberfil.sys")"

Section 'Gaming / Visual'
"Game Mode (AutoGameModeEnabled; not set = on): $(Get-RegValue 'HKCU:\Software\Microsoft\GameBar' AutoGameModeEnabled)"
"Game DVR (GameDVR_Enabled)          : $(Get-RegValue 'HKCU:\System\GameConfigStore' GameDVR_Enabled)"
"App capture (AppCaptureEnabled)     : $(Get-RegValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' AppCaptureEnabled)"
"HAGS (HwSchMode 2=on, 1=off)        : $(Get-RegValue 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' HwSchMode)"
"Visual effects (0 auto,1 look,2 perf,3 custom): $(Get-RegValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' VisualFXSetting)"
"Transparency                        : $(Get-RegValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' EnableTransparency)"
"Mouse acceleration (MouseSpeed)     : $(Get-RegValue 'HKCU:\Control Panel\Mouse' MouseSpeed)"

Section 'Security (informational, do not disable by default)'
$dg = Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -ClassName Win32_DeviceGuard
"VBS status (2 = running): $($dg.VirtualizationBasedSecurityStatus)"
"Memory Integrity (HVCI) : $(Get-RegValue 'HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity' Enabled)"

Section 'Startup apps'
$approved = @{}
foreach ($p in 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run','HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run') {
  $props = Get-ItemProperty $p
  if ($props) { $props.PSObject.Properties | Where-Object { $_.Value -is [byte[]] } | ForEach-Object { $approved[$_.Name] = $_.Value[0] } }
}
Get-CimInstance Win32_StartupCommand | ForEach-Object {
  $state = if ($approved.ContainsKey($_.Name) -and ($approved[$_.Name] % 2) -eq 1) { 'disabled' } else { 'ENABLED' }
  "{0,-9} {1}" -f $state, $_.Name
}

Section 'Developer tools'
foreach ($t in 'git','node','python','dotnet','docker','wsl','code','cargo','java') {
  $c = Get-Command $t -ErrorAction SilentlyContinue
  if ($c) { "found: $t" }
}
$wslcfg = Join-Path $env:USERPROFILE '.wslconfig'
".wslconfig present: $(Test-Path $wslcfg)"
$devDrives = Get-Volume | Where-Object { $_.FileSystemType -eq 'ReFS' }
"ReFS / Dev Drive volumes: $(@($devDrives).Count)"

Section 'Uptime'
"Last boot: $((Get-CimInstance Win32_OperatingSystem).LastBootUpTime)"
