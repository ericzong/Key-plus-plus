[CmdletBinding()]
param()

Trap {
  "Get Exception: $($_.Exception.Message)"
  cd $PSScriptRoot
}

$ErrorActionPreference='Stop'

cd $PSScriptRoot

# ¿½±´ÎÄ¼þ
$files = 'autorun', 'config', 'ico', 'README.md', 'RELEASES.md', 'LICENSE'
switch($files) {
  {Test-Path $_} {
    Copy-Item $_ dist -Force -Recurse
    Write-Host "Copy $_ ..."
  }
}
Start-Sleep -s 1

$script = (Join-Path $PSScriptRoot 'Key++.ahk')
$outExe = [IO.Path]::Combine($PSScriptRoot, 'dist', 'Key++.exe')
$icon = [IO.Path]::Combine($PSScriptRoot, 'ico', 'Key++.ico')
$distDir = (Join-Path $PSScriptRoot 'dist')
$compilerRoot = (Join-Path $PSScriptRoot 'compiler')
$bin32 = (Join-Path $compilerRoot 'AutoHotkey32.exe')
$bin64 = (Join-Path $compilerRoot 'AutoHotkey64.exe')
$zip32 = 'Key++_win32.zip'
$zip64 = 'Key++_x64.zip'
$zipFiles = $files + $outExe

cd $compilerRoot
./Ahk2Exe.exe /in $script /out $outExe /icon $icon /base $bin32 /compress 2 | Out-Null

cd $distDir
7z a $zip32 $zipFiles | Out-Null

cd $compilerRoot
./Ahk2Exe.exe /in $script /out $outExe /icon $icon /bin $bin64 /compress 2 | Out-Null

cd $distDir
7z a $zip64 $zipFiles | Out-Null

# MD5, SHA1, SHA256
$sha256_32 = (certutil -hashfile $zip32 SHA256)[1]
$sha256_64 = (certutil -hashfile $zip64 SHA256)[1]

$text = '* Key++_win32.zip'
$text += "`r`n  "
$text += $sha256_32
$text += "`r`n"
$text += '* Key++_x64.zip'
$text += "`r`n  "
$text += $sha256_64

Set-Clipboard $text

cd $PSScriptRoot