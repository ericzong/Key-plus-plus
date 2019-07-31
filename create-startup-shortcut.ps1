
$shell = New-Object -ComObject WScript.Shell
$startupDir = "$env:appdata\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcut = $shell.CreateShortcut("$startupDir\key++.lnk")
$currentDir = $PSScriptRoot
$keyRootDir = $(Split-Path $currentDir -Parent)
$appsDir = $(Split-Path $keyRootDir -Parent)
$shortcut.TargetPath = "$appsDir\autohotkey\current\AutoHotkeyU64.exe"
$shortcut.Arguments =  "$currentDir\key++.ahk -startup"
$shortcut.WorkingDirectory = "$currentDir"
$shortcut.IconLocation = "$appsDir\autohotkey\current\AutoHotkeyU64.exe,0"
$shortcut.Save()
