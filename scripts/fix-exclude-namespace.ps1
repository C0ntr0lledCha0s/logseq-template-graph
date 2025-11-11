# Fix :exclude-from-graph-view to use proper :logseq.property/ namespace
# The property should be :logseq.property/exclude-from-graph-view, not just :exclude-from-graph-view

Write-Host '[INFO] Fixing exclude-from-graph-view namespace in source files...' -ForegroundColor Cyan
Write-Host ''

$files = Get-ChildItem -Path source -Recurse -Filter *.edn -File | Where-Object { $_.FullName -notlike '*\presets\*' }
$totalFixed = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $originalContent = $content

    # Replace :exclude-from-graph-view with :logseq.property/exclude-from-graph-view
    $content = $content -replace ':exclude-from-graph-view', ':logseq.property/exclude-from-graph-view'

    if ($content -ne $originalContent) {
        # Use UTF-8 without BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)

        $totalFixed++
        Write-Host "[FIX] Fixed namespace in $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ''
if ($totalFixed -gt 0) {
    Write-Host "[SUCCESS] Fixed namespace in $totalFixed file(s)" -ForegroundColor Green
} else {
    Write-Host '[INFO] No files needed fixing' -ForegroundColor Cyan
}
