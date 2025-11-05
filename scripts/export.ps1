# Logseq Template Graph Export Script (PowerShell)
# This script exports your development graph to clean, version-controlled EDN files

# Configuration
$GRAPH_PATH = if ($env:LOGSEQ_GRAPH_PATH) { $env:LOGSEQ_GRAPH_PATH } else { "C:\Users\YourName\Logseq\template-dev" }
$OUTPUT_DIR = "."
$DATE = Get-Date -Format "yyyy-MM-dd"

Write-Host "🚀 Exporting Logseq Template Graph..." -ForegroundColor Cyan
Write-Host "Graph: $GRAPH_PATH" -ForegroundColor Yellow
Write-Host ""

# Check if Logseq CLI is installed
if (-not (Get-Command logseq -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Error: Logseq CLI not found" -ForegroundColor Red
    Write-Host "Install with: npm install -g @logseq/cli" -ForegroundColor Yellow
    exit 1
}

# Check if graph directory exists
if (-not (Test-Path $GRAPH_PATH)) {
    Write-Host "❌ Error: Graph directory not found: $GRAPH_PATH" -ForegroundColor Red
    Write-Host "Set LOGSEQ_GRAPH_PATH environment variable or edit this script" -ForegroundColor Yellow
    exit 1
}

# Export minimal version (no timestamps, clean structure)
Write-Host "📦 Exporting minimal template (recommended for users)..." -ForegroundColor Yellow
logseq export-edn `
    --graph "$GRAPH_PATH" `
    --output "$OUTPUT_DIR\logseq_db_Templates.edn" `
    --ignore-builtin-pages `
    --exclude-namespaces "logseq.kv"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Minimal template exported" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to export minimal template" -ForegroundColor Red
    exit 1
}

# Export full version (with timestamps and full metadata)
Write-Host "📦 Exporting full template (with all metadata)..." -ForegroundColor Yellow
logseq export-edn `
    --graph "$GRAPH_PATH" `
    --output "$OUTPUT_DIR\logseq_db_Templates_full.edn" `
    --include-timestamps

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Full template exported" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to export full template" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Export complete!" -ForegroundColor Green
Write-Host ""

# Show statistics
if (Test-Path "$OUTPUT_DIR\logseq_db_Templates.edn") {
    $MinimalLines = (Get-Content "$OUTPUT_DIR\logseq_db_Templates.edn" | Measure-Object -Line).Lines
    $FullLines = (Get-Content "$OUTPUT_DIR\logseq_db_Templates_full.edn" | Measure-Object -Line).Lines

    Write-Host "📊 Statistics:" -ForegroundColor Cyan
    Write-Host "   Minimal: $MinimalLines lines"
    Write-Host "   Full: $FullLines lines"

    $Content = Get-Content "$OUTPUT_DIR\logseq_db_Templates.edn" -Raw
    $PropCount = ([regex]::Matches($Content, "user\.property/")).Count
    $ClassCount = ([regex]::Matches($Content, "user\.class/")).Count

    Write-Host "   Properties: $PropCount"
    Write-Host "   Classes: $ClassCount"
}

Write-Host ""

# Show git changes
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (Test-Path .git) {
        Write-Host "📊 Git changes:" -ForegroundColor Cyan
        git diff --stat logseq_db_Templates.edn logseq_db_Templates_full.edn 2>$null
        if (-not $?) {
            Write-Host "   No changes detected"
        }
        Write-Host ""
    }
}

# Optional: Auto-commit prompt
Write-Host "Would you like to commit these changes? (y/n)" -ForegroundColor Yellow
$Response = Read-Host "> "

if ($Response -match "^[Yy]$") {
    Write-Host "Enter commit message (or press Enter for default):" -ForegroundColor Yellow
    $CommitMsg = Read-Host "> "

    if ([string]::IsNullOrWhiteSpace($CommitMsg)) {
        $CommitMsg = "chore: auto-export templates on $DATE"
    }

    git add logseq_db_Templates.edn logseq_db_Templates_full.edn
    git commit -m "$CommitMsg"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Changes committed" -ForegroundColor Green
        Write-Host "Push to remote? (y/n)" -ForegroundColor Yellow
        $PushResponse = Read-Host "> "

        if ($PushResponse -match "^[Yy]$") {
            git push
            Write-Host "✅ Changes pushed" -ForegroundColor Green
        }
    } else {
        Write-Host "❌ Failed to commit changes" -ForegroundColor Red
    }
} else {
    Write-Host "💡 Tip: Review changes with: git diff logseq_db_Templates.edn" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Done!" -ForegroundColor Green
