@echo off
title SmartSort — 1-Click PC File Organizer
color 0B
echo ==================================================
echo   SmartSort 1-Click File Organizer (CreatorTools)
echo ==================================================
echo.
echo Organizing files in: "%~dp0"
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = '%~dp0'.TrimEnd('\');" ^
  "$map = @{" ^
  "  'Images'     = @('.jpg','.jpeg','.png','.gif','.webp','.bmp','.svg','.ico','.heic','.raw');" ^
  "  'Videos'     = @('.mp4','.mkv','.mov','.avi','.webm','.flv','.wmv','.m4v');" ^
  "  'Audio'      = @('.mp3','.wav','.flac','.aac','.ogg','.m4a','.wma');" ^
  "  'Documents'  = @('.pdf','.doc','.docx','.txt','.rtf','.odt','.xls','.xlsx','.csv','.ppt','.pptx','.md');" ^
  "  'Archives'   = @('.zip','.rar','.7z','.tar','.gz','.iso');" ^
  "  'Installers' = @('.exe','.msi','.msix','.dmg','.apk');" ^
  "  'Code'       = @('.py','.js','.ts','.html','.css','.json','.xml','.sql','.cpp','.java','.sh')" ^
  "};" ^
  "$skip = @('SmartSort.bat','README.txt');" ^
  "$moved = 0;" ^
  "Get-ChildItem -LiteralPath $root -File | ForEach-Object {" ^
  "  if ($skip -contains $_.Name) { return }" ^
  "  $ext = $_.Extension.ToLower();" ^
  "  $destName = 'Other';" ^
  "  foreach ($k in $map.Keys) { if ($map[$k] -contains $ext) { $destName = $k; break } }" ^
  "  $destDir = Join-Path $root $destName;" ^
  "  if (!(Test-Path -LiteralPath $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }" ^
  "  $target = Join-Path $destDir $_.Name;" ^
  "  $i = 1;" ^
  "  while (Test-Path -LiteralPath $target) {" ^
  "    $target = Join-Path $destDir ($_.BaseName + ' (' + $i + ')' + $_.Extension);" ^
  "    $i++" ^
  "  }" ^
  "  Move-Item -LiteralPath $_.FullName -Destination $target;" ^
  "  $moved++;" ^
  "  Write-Host ('  [Moved] ' + $_.Name + '  ->  ' + $destName + '\')" ^
  "};" ^
  "Write-Host '';" ^
  "Write-Host ('Done! Organized ' + $moved + ' file(s) cleanly.') -ForegroundColor Green"

echo.
pause
