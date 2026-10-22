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
    Write-Host "Source files changed during merge - rebuilding..." -ForegroundColor Cyan
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
        Write-Host "Schema library rebuilt and validated" -ForegroundColor Green
        Write-Host ""
    }
    else {
        Write-Host ""
        Write-Host "Build or validation failed after merge!" -ForegroundColor Red
        Write-Host "Run: bb test && bb build && bb validate"
        Write-Host ""
        exit 1
    }
}
