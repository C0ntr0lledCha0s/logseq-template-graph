# Logseq Template Graph Export Script (PowerShell)
# This script exports your development graph to clean, version-controlled EDN files

# Configuration
$GRAPH_PATH = if ($env:LOGSEQ_GRAPH_PATH) { $env:LOGSEQ_GRAPH_PATH } else { "$env:USERPROFILE\logseq\graphs\Test Build" }
$OUTPUT_DIR = if ($env:LOGSEQ_OUTPUT_DIR) { $env:LOGSEQ_OUTPUT_DIR } else { "archive/pre-modular" }

Write-Host "Exporting Logseq Template Graph..." -ForegroundColor Cyan
Write-Host "Graph: $GRAPH_PATH" -ForegroundColor Yellow
Write-Host ""

# Check if npx is available
if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
    Write-Host "Error: npx not found (Node.js required)" -ForegroundColor Red
    Write-Host "Install Node.js from: https://nodejs.org" -ForegroundColor Yellow
    exit 1
}

# Check if graph directory exists
if (-not (Test-Path $GRAPH_PATH)) {
    Write-Host "Error: Graph directory not found: $GRAPH_PATH" -ForegroundColor Red
    Write-Host "Set LOGSEQ_GRAPH_PATH environment variable or edit this script" -ForegroundColor Yellow
    exit 1
}

# Convert Windows paths to forward slashes for Logseq CLI
$GRAPH_PATH_CLI = $GRAPH_PATH -replace '\\', '/'

# Get absolute path for output directory
if ($OUTPUT_DIR -eq ".") {
    $OUTPUT_DIR_ABS = (Get-Location).Path
} elseif (Test-Path $OUTPUT_DIR) {
    $OUTPUT_DIR_ABS = (Resolve-Path $OUTPUT_DIR).Path
} else {
    # Handle relative paths that don't exist yet
    $OUTPUT_DIR_ABS = Join-Path (Get-Location).Path $OUTPUT_DIR
    # Create directory if it doesn't exist
    if (-not (Test-Path $OUTPUT_DIR_ABS)) {
        New-Item -ItemType Directory -Path $OUTPUT_DIR_ABS -Force | Out-Null
        Write-Host "Created output directory: $OUTPUT_DIR_ABS" -ForegroundColor Green
    }
}
$OUTPUT_DIR_CLI = $OUTPUT_DIR_ABS -replace '\\', '/'

Write-Host "Output directory: $OUTPUT_DIR_CLI" -ForegroundColor Cyan
Write-Host ""

# Export template (clean, no timestamps)
Write-Host "Exporting template..." -ForegroundColor Yellow
$OUTPUT_FILE = "$OUTPUT_DIR_CLI/logseq_db_Templates.edn"
Write-Host "Target file: $OUTPUT_FILE" -ForegroundColor Cyan
npx logseq export-edn `
    "$GRAPH_PATH_CLI" `
    --file "$OUTPUT_FILE" `
    --exclude-built-in-pages `
    --exclude-namespaces "logseq.kv"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Template exported successfully" -ForegroundColor Green
} else {
    Write-Host "Failed to export template" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Export complete!" -ForegroundColor Green
Write-Host ""

# Show statistics
$TemplateFile = Join-Path $OUTPUT_DIR_ABS "logseq_db_Templates.edn"
if (Test-Path $TemplateFile) {
    $Lines = (Get-Content $TemplateFile | Measure-Object -Line).Lines
    $Content = Get-Content $TemplateFile -Raw
    $PropCount = ([regex]::Matches($Content, "user\.property/")).Count
    $ClassCount = ([regex]::Matches($Content, "user\.class/")).Count

    Write-Host "Statistics:" -ForegroundColor Cyan
    Write-Host "   Lines: $Lines"
    Write-Host "   Properties: $PropCount"
    Write-Host "   Classes: $ClassCount"
}

Write-Host ""

# Show git changes
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (Test-Path .git) {
        Write-Host "Git changes:" -ForegroundColor Cyan
        git diff --stat archive/pre-modular/logseq_db_Templates.edn 2>$null
        if (-not $?) {
            Write-Host "   No changes detected"
        }
        Write-Host ""
    }
}

Write-Host ""
Write-Host "Splitting template into modules..." -ForegroundColor Yellow

# Check if babashka is available
if (Get-Command bb -ErrorAction SilentlyContinue) {
    bb scripts/split.clj
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Modules updated successfully" -ForegroundColor Green
    } else {
        Write-Host "Warning: Split script failed" -ForegroundColor Red
    }
} else {
    Write-Host "Warning: Babashka (bb) not found - skipping module split" -ForegroundColor Yellow
    Write-Host "Install from: https://babashka.org/" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  - Review changes: git diff src/" -ForegroundColor Gray
Write-Host "  - Build variants: bb scripts/build.clj full" -ForegroundColor Gray
Write-Host "  - Commit changes: git add . && git commit -m 'feat: describe changes'" -ForegroundColor Gray
Write-Host "  - Push to remote: git push" -ForegroundColor Gray
