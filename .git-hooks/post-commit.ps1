# Post-commit hook - Validate build after committing to source/
# This hook runs after a successful commit to ensure source changes build correctly
# PowerShell version for Windows

$ErrorActionPreference = "Stop"

# Check if source/ directory was modified in the last commit
$changedFiles = git diff HEAD~1 HEAD --name-only

if ($changedFiles -match "^source/") {
    Write-Host ""
    Write-Host "Source files modified - validating build..." -ForegroundColor Cyan
    Write-Host ""

    # Run build and validation
    bb build 2>&1 | Select-Object -Last 5 | Write-Host
    $buildExit = $LASTEXITCODE
    if ($buildExit -eq 0) {
        bb validate 2>&1 | Select-Object -Last 5 | Write-Host
        $buildExit = $LASTEXITCODE
    }
    if ($buildExit -eq 0) {
        Write-Host ""
        Write-Host "Build and validation passed" -ForegroundColor Green
        Write-Host ""
    }
    else {
        Write-Host ""
        Write-Host "Build or validation failed after commit!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Options:" -ForegroundColor Yellow
        Write-Host "  1. Run bb test && bb build && bb validate and fix the reported errors"
        Write-Host "  2. git reset HEAD~ to undo the commit"
        Write-Host "  3. git commit --amend to fix and retry"
        Write-Host ""
        exit 1
    }
}
