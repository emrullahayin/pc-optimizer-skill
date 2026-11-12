# pc-optimizer: read-only check that optimize.ps1 was applied. Changes nothing.
function Get-RegValue($Path, $Name) {
  try { (Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop).$Name } catch { $null }
}
function Row($name, $ok, $detail) {
  $mark = if ($ok) { 'OK  ' } else { 'TODO' }
  $color = if ($ok) { 'Green' } else { 'Yellow' }
  Write-Host ("[{0}] {1,-28} {2}" -f $mark, $name, $detail) -ForegroundColor $color
}

$plan = powercfg /getactivescheme
Row 'Performance power plan' ($plan -notmatch '381b4222-f694-41f0-9685-ff5bb260df2e|a1841308-3541-4fab-bc81-f71556f20b4a') ($plan -replace '^.*?:\s*','')
$gm = Get-RegValue 'HKCU:\Software\Microsoft\GameBar' AutoGameModeEnabled
Row 'Game Mode' ($gm -ne 0) "AutoGameModeEnabled=$gm"
$dvr = Get-RegValue 'HKCU:\System\GameConfigStore' GameDVR_Enabled
Row 'Game DVR off' ($dvr -eq 0) "GameDVR_Enabled=$dvr"
$fx = Get-RegValue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' VisualFXSetting
Row 'Visual effects' ($fx -in 2,3) "VisualFXSetting=$fx"
$ms = Get-RegValue 'HKCU:\Control Panel\Mouse' MouseSpeed
Row 'Mouse acceleration off' ($ms -eq '0') "MouseSpeed=$ms"
$fs = Get-RegValue 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' HiberbootEnabled
Row 'Fast Startup off' ($fs -eq 0) "HiberbootEnabled=$fs (left on for laptops)"
$hz = (Get-CimInstance Win32_VideoController | Select-Object -First 1).CurrentRefreshRate
Row 'Refresh rate' ($hz -ge 100) "$hz Hz (check it matches the monitor's max)"

$boot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$state = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PcOptimizerBackup\state.json'
if (Test-Path $state) {
  $applied = (Get-Item $state).LastWriteTime
  Row 'Rebooted after changes' ($boot -gt $applied) "last boot $boot, changes $applied"
} else {
  Row 'Backup present' $false 'no PcOptimizerBackup\state.json - optimize.ps1 may not have run'
}
