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
# 拷贝文件
$files = 'autorun', 'config', 'hotkey.png','hotkey_pause.png', 'hotkey_suspend.png', 'README.md', 'RELEASES.md', 'LICENSE'
switch($files) {
  {Test-Path $_} {
    copy $_ dist -Force -Recurse
    Write-Host "Copy $_ ..."
  }
}
Start-Sleep -s 1

$script = (Join-Path $PSScriptRoot 'Key++.ahk')
$outExe = [IO.Path]::Combine($PSScriptRoot, 'dist', 'Key++.exe')
$icon = [IO.Path]::Combine($PSScriptRoot, 'ico', 'Key++.ico')
$distDir = (Join-Path $PSScriptRoot 'dist')
$bin32 = (Join-Path $compilerRoot 'Unicode 32-bit.bin')
$bin64 = (Join-Path $compilerRoot 'Unicode 64-bit.bin')
$zip32 = 'Key++_win32.zip'
$zip64 = 'Key++_win64.zip'
$zipFiles = $files + $outExe

# FAQ.01 数组中的第一个文件夹(这里是 autorun)由于某种原因可能拷贝失败
# 如果拷贝失败，就创建一个
cd $distDir
if(-not (Test-Path $files[0])) {
  mkdir $files[0]
}

cd $PSScriptRoot
ahk2exe /in $script /out $outExe /icon $icon /bin $bin32 /mpress 1
Start-Sleep -s 5

cd $distDir
7z a $zip32 $zipFiles
Start-Sleep -s 5

cd $PSScriptRoot
ahk2exe /in $script /out $outExe /icon $icon /bin $bin64 /mpress 1
Start-Sleep -s 5

cd $distDir
7z a $zip64 $zipFiles
Start-Sleep -s 5

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