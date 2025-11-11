# Remove :exclude-from-graph-view property from all source files
# This property is not supported by Logseq and causes import errors

Write-Host '[INFO] Removing :exclude-from-graph-view from source files...' -ForegroundColor Cyan
Write-Host ''

$files = Get-ChildItem -Path source -Recurse -Filter *.edn -File | Where-Object { $_.FullName -notlike '*\presets\*' }
$totalFixed = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $originalContent = $content

    # Replace pattern: "description",\n    :exclude-from-graph-view true}},
    # With: "description"}},
    $content = $content -replace '(".*?"),\r?\n\s*:exclude-from-graph-view true\}\},',("`$1}},")

    if ($content -ne $originalContent) {
        # Use UTF-8 without BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)

        $totalFixed++
        Write-Host "[FIX] Cleaned $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ''
if ($totalFixed -gt 0) {
    Write-Host "[SUCCESS] Removed :exclude-from-graph-view from $totalFixed file(s)" -ForegroundColor Green
} else {
    Write-Host '[INFO] No files needed cleaning' -ForegroundColor Cyan
}
