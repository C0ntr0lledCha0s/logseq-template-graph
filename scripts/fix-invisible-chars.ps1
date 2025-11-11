# Fix invisible characters in source files
# Replaces non-breaking spaces and zero-width characters with normal characters
# NOTE: Preserves zero-width joiners in emoji :native fields (they're intentional)

Write-Host '[INFO] Fixing invisible characters in source files...' -ForegroundColor Cyan
Write-Host ''

$files = Get-ChildItem -Path source -Recurse -Filter *.edn -File | Where-Object { $_.FullName -notlike '*\presets\*' }
$totalFixed = 0
$filesFixed = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $originalContent = $content
    $fixCount = 0

    # Replace non-breaking spaces with regular spaces
    $nbsp = [char]0x00A0
    if ($content.Contains($nbsp)) {
        $count = ([regex]::Matches($content, [regex]::Escape($nbsp))).Count
        $content = $content.Replace($nbsp, ' ')
        $fixCount += $count
        Write-Host "[FIX] Replaced $count non-breaking space(s) in $($file.Name)" -ForegroundColor Yellow
    }

    # Note: Zero-width joiners (U+200D) are intentionally preserved
    # They are part of emoji specification for composite emojis
    # (e.g., "????" = man + ZWJ + woman + ZWJ + girl)

    # Remove zero-width spaces
    $zws = [char]0x200B
    $zwsStr = [string]$zws
    if ($content.Contains($zws)) {
        $count = ([regex]::Matches($content, [regex]::Escape($zwsStr))).Count
        $content = $content.Replace($zwsStr, '')
        $fixCount += $count
        Write-Host "[FIX] Removed $count zero-width space(s) in $($file.Name)" -ForegroundColor Yellow
    }

    # Remove zero-width non-joiners
    $zwnj = [char]0x200C
    $zwnjStr = [string]$zwnj
    if ($content.Contains($zwnj)) {
        $count = ([regex]::Matches($content, [regex]::Escape($zwnjStr))).Count
        $content = $content.Replace($zwnjStr, '')
        $fixCount += $count
        Write-Host "[FIX] Removed $count zero-width non-joiner(s) in $($file.Name)" -ForegroundColor Yellow
    }

    # Remove zero-width no-break spaces (BOM when not at start)
    $zwnbsp = [char]0xFEFF
    $zwnbspStr = [string]$zwnbsp
    if ($content.Contains($zwnbsp)) {
        $count = ([regex]::Matches($content, [regex]::Escape($zwnbspStr))).Count
        $content = $content.Replace($zwnbspStr, '')
        $fixCount += $count
        Write-Host "[FIX] Removed $count zero-width no-break space(s) in $($file.Name)" -ForegroundColor Yellow
    }

    # Write back if changes were made
    if ($content -ne $originalContent) {
        # Use UTF-8 without BOM
        $utf8NoBom = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)

        $totalFixed += $fixCount
        $filesFixed++
    }
}

Write-Host ''
if ($filesFixed -gt 0) {
    Write-Host "[SUCCESS] Fixed $totalFixed invisible character(s) in $filesFixed file(s)" -ForegroundColor Green
} else {
    Write-Host '[SUCCESS] No invisible characters found to fix' -ForegroundColor Green
}
