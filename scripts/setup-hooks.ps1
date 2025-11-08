# Setup script for git hooks (conventional commits + build validation)
# PowerShell version for Windows

Write-Host "Setting up git hooks..." -ForegroundColor Cyan

try {
    # Configure git to use .git-hooks directory
    git config core.hooksPath .git-hooks

    # On Windows, we need to create shell wrappers that call PowerShell
    # Each hook needs a wrapper that invokes the corresponding .ps1 file

    # commit-msg hook wrapper
    $commitMsgWrapper = @"
#!/bin/sh
powershell.exe -ExecutionPolicy Bypass -File .git-hooks/commit-msg.ps1 `$1
"@
    Set-Content -Path ".git-hooks\commit-msg" -Value $commitMsgWrapper -NoNewline

    # post-commit hook wrapper
    $postCommitWrapper = @"
#!/bin/sh
powershell.exe -ExecutionPolicy Bypass -File .git-hooks/post-commit.ps1
"@
    Set-Content -Path ".git-hooks\post-commit" -Value $postCommitWrapper -NoNewline

    # pre-push hook wrapper
    $prePushWrapper = @"
#!/bin/sh
powershell.exe -ExecutionPolicy Bypass -File .git-hooks/pre-push.ps1 `$1 `$2
"@
    Set-Content -Path ".git-hooks\pre-push" -Value $prePushWrapper -NoNewline

    # post-merge hook wrapper
    $postMergeWrapper = @"
#!/bin/sh
powershell.exe -ExecutionPolicy Bypass -File .git-hooks/post-merge.ps1
"@
    Set-Content -Path ".git-hooks\post-merge" -Value $postMergeWrapper -NoNewline

    Write-Host "[OK] Git hooks configured successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Active hooks:" -ForegroundColor Yellow
    Write-Host "  • commit-msg   - Validates conventional commits format"
    Write-Host "  • post-commit  - Validates build after source/ changes"
    Write-Host "  • pre-push     - Comprehensive validation before pushing"
    Write-Host "  • post-merge   - Auto-rebuild after merge/pull"
    Write-Host ""
    Write-Host "Example valid commit: feat(templates): add Recipe class with ingredients property" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To bypass hooks (not recommended): git commit --no-verify" -ForegroundColor Gray
}
catch {
    Write-Host "Error setting up hooks: $_" -ForegroundColor Red
    exit 1
}
