# Post-merge hook - Auto-rebuild after merging changes to source/
# This hook runs after successful merge or pull operations
# PowerShell version for Windows

$ErrorActionPreference = "Stop"

# Check if source/ directory was modified during the merge
try {
    $changedFiles = git diff 'HEAD@{1}' HEAD --name-only 2>$null
}
catch {
    $changedFiles = ""
}

if ($changedFiles -match "^source/") {
    Write-Host ""
    Write-Host "📦 Source modules changed during merge - rebuilding..." -ForegroundColor Cyan
    Write-Host ""

    # Run build
    try {
        $buildOutput = npm run build:full 2>&1 | Select-Object -Last 5
        Write-Host $buildOutput

        Write-Host ""
        Write-Host "✓ Templates rebuilt successfully" -ForegroundColor Green
        Write-Host ""
        Write-Host "⚠️  Review changes in build/ directory before committing." -ForegroundColor Yellow
        Write-Host ""
    }
    catch {
        Write-Host ""
        Write-Host "❌ Build failed after merge!" -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 Run '/diagnose full' in Claude Code for analysis" -ForegroundColor Yellow
        Write-Host "Or run: npm run build:full"
        Write-Host ""
        exit 1
    }
}
