# Setup script for git conventional commits hooks (PowerShell version for Windows)

Write-Host "Setting up git hooks for conventional commits..." -ForegroundColor Cyan

try {
    # Configure git to use .git-hooks directory and the PowerShell hook
    git config core.hooksPath .git-hooks

    # On Windows, we need to configure git to use PowerShell for the hook
    $hookContent = @"
#!/bin/sh
powershell.exe -ExecutionPolicy Bypass -File .git-hooks/commit-msg.ps1 `$1
"@

    # Write the shell wrapper that calls PowerShell
    Set-Content -Path ".git-hooks\commit-msg" -Value $hookContent -NoNewline

    Write-Host "[OK] Git hooks configured successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Commit messages will now be validated against conventional commits standard." -ForegroundColor Yellow
    Write-Host "Example valid commit: feat(templates): add Recipe class with ingredients property" -ForegroundColor Gray
    Write-Host ""
    Write-Host "To bypass validation (not recommended): git commit --no-verify" -ForegroundColor Gray
}
catch {
    Write-Host "Error setting up hooks: $_" -ForegroundColor Red
    exit 1
}
