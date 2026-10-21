# Check for BOM markers and encoding issues in source files

Write-Host '[INFO] Checking for BOM markers in source files...' -ForegroundColor Cyan
Write-Host ''

$files = Get-ChildItem -Path source -Recurse -Filter *.edn -File | Where-Object { $_.FullName -notlike '*\presets\*' }
$bomFiles = @()

foreach ($file in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)

    # Check for UTF-8 BOM (EF BB BF)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        $bomFiles += $file.FullName
        Write-Host '[WARNING] UTF-8 BOM found in:' $file.Name -ForegroundColor Yellow
    }

    # Check for UTF-16 LE BOM (FF FE)
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) {
        $bomFiles += $file.FullName
        Write-Host '[ERROR] UTF-16 LE BOM found in:' $file.Name -ForegroundColor Red
    }

    # Check for UTF-16 BE BOM (FE FF)
    if ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) {
        $bomFiles += $file.FullName
        Write-Host '[ERROR] UTF-16 BE BOM found in:' $file.Name -ForegroundColor Red
    }
}

Write-Host ''
if ($bomFiles.Count -gt 0) {
    Write-Host '[INFO] Found' $bomFiles.Count 'files with BOM markers' -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'Files with BOM:' -ForegroundColor Yellow
    foreach ($f in $bomFiles) {
        Write-Host "  $f"
    }
} else {
    Write-Host '[SUCCESS] No BOM markers found in any source files' -ForegroundColor Green
}
