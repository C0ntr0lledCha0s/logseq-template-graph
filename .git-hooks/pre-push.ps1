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

# Check 2: Validate all template variants build successfully
Write-Host "[BUILD] Building all template variants..." -ForegroundColor Cyan
Write-Host ""

$buildFailed = $false

# Build full variant
try {
    npm run build:full 2>&1 | Out-Null
}
catch {
    Write-Host "[ERROR] Full template build failed" -ForegroundColor Red
    $buildFailed = $true
}

# Build CRM variant
try {
    npm run build:crm 2>&1 | Out-Null
}
catch {
    Write-Host "[ERROR] CRM template build failed" -ForegroundColor Red
    $buildFailed = $true
}

# Build research variant
try {
    npm run build:research 2>&1 | Out-Null
}
catch {
    Write-Host "[ERROR] Research template build failed" -ForegroundColor Red
    $buildFailed = $true
}

if ($buildFailed) {
    Write-Host ""
    Write-Host "Run /diagnose in Claude Code for detailed analysis" -ForegroundColor Yellow
    Write-Host "Or run: npm run build:full"
    Write-Host ""
    exit 1
}

Write-Host "✓ All template variants built successfully" -ForegroundColor Green
Write-Host ""

# Check 3: Validate UUID references in source files
Write-Host "[VALIDATE] Checking UUID references in source files..." -ForegroundColor Cyan
Write-Host ""

if (Test-Path "source") {
    if (Get-Command bb -ErrorAction SilentlyContinue) {
        try {
            bb scripts/validate-refs.clj
            if ($LASTEXITCODE -ne 0) {
                Write-Host ""
                Write-Host "[ERROR] UUID reference validation failed" -ForegroundColor Red
                Write-Host "Please fix broken UUID references before pushing" -ForegroundColor Yellow
                Write-Host ""
                exit 1
            }
            Write-Host "OK All UUID references valid" -ForegroundColor Green
        }
        catch {
            Write-Host "[ERROR] UUID validation script failed to execute" -ForegroundColor Red
            exit 1
        }
    }
    else {
        Write-Host "[WARNING] Babashka not installed - skipping UUID validation" -ForegroundColor Yellow
    }
}
else {
    Write-Host "[INFO] source/ directory not found - skipping UUID validation" -ForegroundColor Cyan
}

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
    $conventionalPattern = '^(feat|fix|docs|style|refactor|perf|test|build|ops|chore)(\(.+\))?: .+'

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
