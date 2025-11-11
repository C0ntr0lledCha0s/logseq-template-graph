# Check for invisible/control characters in source files
# NOTE: Skips zero-width joiners in emoji :native fields (they're intentional)

Write-Host '[INFO] Checking for invisible characters in source files...' -ForegroundColor Cyan
Write-Host ''

$files = Get-ChildItem -Path source -Recurse -Filter *.edn -File | Where-Object { $_.FullName -notlike '*\presets\*' }
$issuesFound = 0

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    $lines = $content -split "`n"
    $lineNum = 0
    $fileHasIssues = $false
    $inEmojiContext = $false

    foreach ($line in $lines) {
        $lineNum++

        # Track if we're in an emoji icon context
        if ($line -match ':type :emoji}') {
            $inEmojiContext = $false
        }
        if ($line -match ':id "emoji"' -or $line -match ':native' -or $line -match ':search' -or $line -match ':unified' -or $line -match ':shortcodes' -or $line -match ':skins') {
            $inEmojiContext = $true
        }

        # Skip emoji-related lines (zero-width joiners are intentional in emoji)
        if ($inEmojiContext) {
            continue
        }

        # Check for various invisible/problematic characters
        $issues = @()

        # Zero-width characters
        if ($line -match '\u200B') { $issues += 'Zero-width space (U+200B)' }
        if ($line -match '\u200C') { $issues += 'Zero-width non-joiner (U+200C)' }
        if ($line -match '\u200D') { $issues += 'Zero-width joiner (U+200D)' }
        if ($line -match '\uFEFF') { $issues += 'Zero-width no-break space (U+FEFF)' }

        # Non-breaking spaces
        if ($line -match '\u00A0') { $issues += 'Non-breaking space (U+00A0)' }

        # Tab characters (should use spaces in EDN)
        if ($line -match '\t') { $issues += 'Tab character' }

        # Control characters (except newline and carriage return)
        if ($line -match '[\x00-\x08\x0B-\x0C\x0E-\x1F\x7F]') { $issues += 'Control character' }

        if ($issues.Count -gt 0) {
            if (-not $fileHasIssues) {
                Write-Host ''
                Write-Host '[WARNING]' $file.Name -ForegroundColor Yellow
                $fileHasIssues = $true
            }
            Write-Host "  Line ${lineNum}: $($issues -join ', ')" -ForegroundColor Yellow
            $issuesFound++
        }
    }
}

Write-Host ''
if ($issuesFound -gt 0) {
    Write-Host '[INFO] Found invisible character issues in' $issuesFound 'lines' -ForegroundColor Yellow
} else {
    Write-Host '[SUCCESS] No invisible character issues found' -ForegroundColor Green
}
