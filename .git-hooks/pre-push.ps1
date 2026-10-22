# Pre-push hook - Comprehensive validation before pushing to remote
# This hook prevents broken builds from reaching the remote repository
# PowerShell version for Windows

param($Remote, $RemoteUrl)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "[PRE-PUSH] Running validation..." -ForegroundColor Cyan
Write-Host ""

# Check 1: Verify no uncommitted changes in source/
$uncommittedChanges = git status --porcelain | Select-String "^.M source/"

if ($uncommittedChanges) {
    Write-Host "[ERROR] Uncommitted changes detected in source/" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please commit or stash changes before pushing:"
    $uncommittedChanges | ForEach-Object { Write-Host "  $_" }
    Write-Host ""
    exit 1
}

# Check 2: Run unit tests, build the schema library and validate it
Write-Host "[BUILD] Running bb test, bb build and bb validate..." -ForegroundColor Cyan
Write-Host ""

if (-not (Get-Command bb -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Babashka (bb) not installed - see https://babashka.org/" -ForegroundColor Red
    exit 1
}

foreach ($task in @("test", "build", "validate")) {
    bb $task 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "[ERROR] bb $task failed" -ForegroundColor Red
        Write-Host "Run: bb $task"
        Write-Host ""
        exit 1
    }
}

Write-Host "OK Tests, build and validation passed" -ForegroundColor Green
Write-Host ""

# Check 4: Validate conventional commit messages for unpushed commits
Write-Host "[CHECK] Validating commit messages..." -ForegroundColor Cyan

# Get the remote branch we're pushing to
$remoteBranch = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
if (-not $remoteBranch) {
    $remoteBranch = "origin/main"
}

# Get commits that will be pushed
$unpushedCommits = git log "$remoteBranch..HEAD" --oneline 2>$null
if (-not $unpushedCommits) {
    $unpushedCommits = git log HEAD --oneline -10
}

if ($unpushedCommits) {
    $conventionalPattern = '^(feat|fix|docs|style|refactor|perf|test|build|ops|chore)(\(.+\))?!?: .+'

    foreach ($commit in $unpushedCommits) {
        $commitMsg = $commit -replace '^\w+\s+', ''

        if ($commitMsg -notmatch $conventionalPattern) {
            Write-Host ""
            Write-Host "[ERROR] Invalid commit message format detected:" -ForegroundColor Red
            Write-Host "   $commitMsg" -ForegroundColor Yellow
            Write-Host ""
            Write-Host 'Expected format: type(scope): description'
            Write-Host 'Example: feat(classes): add Recipe class'
            Write-Host ""
            Write-Host 'Valid types: feat, fix, docs, style, refactor, perf, test, build, ops, chore'
            Write-Host ""
            exit 1
        }
    }
}

Write-Host "✓ All commit messages follow conventional commits format" -ForegroundColor Green
Write-Host ""

# All checks passed
Write-Host "[SUCCESS] Pre-push validation completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "[PUSH] Pushing to remote..." -ForegroundColor Cyan
Write-Host ""

exit 0
