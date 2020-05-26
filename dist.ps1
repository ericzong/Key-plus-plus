[CmdletBinding()]
param(
  [Parameter(Position=0, Mandatory)]
  [string]$compilerRoot
)

# ¿½±´ÎÄ¼þ
$files = './autorun', './config', './hotkey.png','.\hotkey_pause.png', '.\hotkey_suspend.png', '.\README.md', '.\RELEASES.md', '.\LICENSE'
foreach($f in $files) {
  if(Test-Path $f) {
    copy (Resolve-Path $f) .\dist -Force -Recurse
  }
}

$script = '.\Key++.ahk'
$outExe = '.\dist\Key++.exe'
$icon = '.\ico\Key++.ico'
$bin32 = (Join-Path $compilerRoot 'Unicode 32-bit.bin')
$bin64 = (Join-Path $compilerRoot 'Unicode 64-bit.bin')
$zip32 = (Join-Path $PSScriptRoot 'Key++_win32.zip')
$zip64 = (Join-Path $PSScriptRoot 'Key++_win64.zip')
$zipFiles = $files, $outExe

ahk2exe /in $script /out $outExe /icon $icon /bin $bin32 /mpress 1
7z a $zip32 $zipFiles

ahk2exe /in $script /out $outExe /icon $icon /bin $bin64 /mpress 1
7z a $zip64 $zipFiles