# Post-commit hook - Validate build after committing to source/
# This hook runs after a successful commit to ensure source changes build correctly
# PowerShell version for Windows

$ErrorActionPreference = "Stop"

# Check if source/ directory was modified in the last commit
$changedFiles = git diff HEAD~1 HEAD --name-only

if ($changedFiles -match "^source/") {
    Write-Host ""
    Write-Host "🔨 Source files modified - validating build..." -ForegroundColor Cyan
    Write-Host ""

    # Run build
    try {
        $buildOutput = npm run build:full 2>&1 | Select-Object -Last 10
        Write-Host $buildOutput

        # Count lines in built file
        $buildFile = "build/logseq_db_Templates_full.edn"
        if (Test-Path $buildFile) {
            $lineCount = (Get-Content $buildFile).Count
            Write-Host ""
            Write-Host "✓ Build validated successfully! ($lineCount lines)" -ForegroundColor Green
            Write-Host ""
        }
        else {
            Write-Host ""
            Write-Host "✓ Build completed" -ForegroundColor Green
            Write-Host ""
        }
    }
    catch {
        Write-Host ""
        Write-Host "❌ Build failed after commit!" -ForegroundColor Red
        Write-Host ""
        Write-Host "💡 Options:" -ForegroundColor Yellow
        Write-Host "  1. Run '/diagnose full' in Claude Code for analysis"
        Write-Host "  2. git reset HEAD~  - Undo the commit"
        Write-Host "  3. git commit --amend  - Fix and retry"
        Write-Host ""
        Write-Host "Review the error above or run /diagnose for help."
        exit 1
    }
}
