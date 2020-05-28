[CmdletBinding()]
param(
  [Parameter(Position=0, Mandatory)]
  [string]$compilerRoot
)

Trap {
  "Get Exception: $($_.Exception.Message)"
  cd $PSScriptRoot
}

$ErrorActionPreference='Stop'

cd $PSScriptRoot
# ¿½±´ÎÄ¼þ
$files = 'autorun', 'config', 'hotkey.png','hotkey_pause.png', 'hotkey_suspend.png', 'README.md', 'RELEASES.md', 'LICENSE'
switch($files) {
  {Test-Path $_} {
    copy $_ dist -Force -Recurse
    Write-Host "Copy $_ ..."
  }
}

$script = (Join-Path $PSScriptRoot 'Key++.ahk')
$outExe = [IO.Path]::Combine($PSScriptRoot, 'dist', 'Key++.exe')
$icon = [IO.Path]::Combine($PSScriptRoot, 'ico', 'Key++.ico')
$distDir = (Join-Path $PSScriptRoot 'dist')
$bin32 = (Join-Path $compilerRoot 'Unicode 32-bit.bin')
$bin64 = (Join-Path $compilerRoot 'Unicode 64-bit.bin')
$zip32 = 'Key++_win32.zip'
$zip64 = 'Key++_win64.zip'
$zipFiles = $files + $outExe

cd $distDir
if(-not (Test-Path $files[0])) {
  mkdir $files[0]
}

cd $PSScriptRoot
ahk2exe /in $script /out $outExe /icon $icon /bin $bin32 /mpress 1
cd $distDir
7z a $zip32 $zipFiles

cd $PSScriptRoot
ahk2exe /in $script /out $outExe /icon $icon /bin $bin64 /mpress 1
cd $distDir
7z a $zip64 $zipFiles

cd $PSScriptRoot