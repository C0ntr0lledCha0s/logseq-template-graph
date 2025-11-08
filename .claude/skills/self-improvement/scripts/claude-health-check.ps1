# CLAUDE.md Health Check Script (PowerShell)
# Part of self-improvement skill

param()

$ErrorActionPreference = "Continue"

# Configuration
$claudeFile = "CLAUDE.md"
$threshold = 600
$warningThreshold = 550
$outputDir = ".claude/analysis"
$timestamp = Get-Date -Format "yyyy-MM-dd"

Write-Host ""
Write-Host "======================================="
Write-Host "  CLAUDE.md Health Check"
Write-Host "======================================="
Write-Host ""

# Check if CLAUDE.md exists
if (-not (Test-Path $claudeFile)) {
    Write-Host "[ERROR] $claudeFile not found" -ForegroundColor Red
    exit 1
}

# Create output directory
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

# Start report
$report = "$outputDir/claude-health-$timestamp.md"

# 1. Measure file size
$lineCount = (Get-Content $claudeFile | Measure-Object -Line).Lines
$percent = [math]::Round(($lineCount * 100 / $threshold), 1)

# Determine status
$status = "[SUCCESS] Healthy"
$statusEmoji = "Healthy"
$statusColor = "Green"

if ($lineCount -gt $threshold) {
    $status = "[ERROR] Action Required"
    $statusEmoji = "Action Required"
    $statusColor = "Red"
} elseif ($lineCount -gt $warningThreshold) {
    $status = "[WARNING] Needs Attention"
    $statusEmoji = "Needs Attention"
    $statusColor = "Yellow"
}

Write-Host "Status: $statusEmoji" -ForegroundColor $statusColor
Write-Host "Size: $lineCount / $threshold lines ($percent%)"
Write-Host ""

# 2. Count sections
$sections = Get-Content $claudeFile | Select-String -Pattern "^## "
$sectionCount = ($sections | Measure-Object).Count

Write-Host "Sections: $sectionCount"

# 3. Analyze section sizes
Write-Host "Analyzing section sizes..."

$sectionData = @()
$largeSections = @()

for ($i = 0; $i -lt $sections.Count; $i++) {
    $currentLine = $sections[$i].LineNumber
    $sectionName = $sections[$i].Line -replace '^## ', ''

    # Find next section or end of file
    if ($i -lt ($sections.Count - 1)) {
        $nextLine = $sections[$i + 1].LineNumber
    } else {
        $nextLine = $lineCount
    }

    $sectionSize = $nextLine - $currentLine

    $sectionData += [PSCustomObject]@{
        Name = $sectionName
        Size = $sectionSize
        Line = $currentLine
    }

    if ($sectionSize -gt 100) {
        $largeSections += "- **$sectionName** ($sectionSize lines, starts line $currentLine)"
    }
}

# 4. Count links
$content = Get-Content $claudeFile -Raw
$internalLinks = ([regex]::Matches($content, '\[.*?\]\(\..*?\.md\)')).Count
$externalLinks = ([regex]::Matches($content, '\[.*?\]\(http.*?\)')).Count

# 5. Check last modified
$lastModified = git log -1 --format="%ad" --date=short -- $claudeFile 2>$null
if (-not $lastModified) { $lastModified = "Unknown" }

# Generate report
@"
# CLAUDE.md Health Check

**Date:** $timestamp
**Status:** $statusEmoji

---

## Metrics

- **Size:** $lineCount lines (target: <$threshold)
- **Percentage:** $percent% of threshold
- **Sections:** $sectionCount
- **Avg Section Length:** $([math]::Floor($lineCount / $sectionCount)) lines
- **Internal Links:** $internalLinks
- **External Links:** $externalLinks
- **Last Updated:** $lastModified

---

## Section Sizes

"@ | Out-File -FilePath $report -Encoding UTF8

$sectionData | Sort-Object Size -Descending | ForEach-Object {
    "$($_.Size) lines - $($_.Name)"
} | Out-File -FilePath $report -Append -Encoding UTF8

@"

---

## Issues Found

"@ | Out-File -FilePath $report -Append -Encoding UTF8

# Add issues based on status
if ($lineCount -gt $threshold) {
    @"
### [ERROR] Critical

**File size exceeds threshold!**
- Current: $lineCount lines
- Threshold: $threshold lines
- Overage: $($lineCount - $threshold) lines

**Action Required:** Extract large sections immediately

"@ | Out-File -FilePath $report -Append -Encoding UTF8
}

if ($largeSections.Count -gt 0) {
    @"
### [WARNING] Warnings

**Large Sections (>100 lines):**
$($largeSections -join "`n")

**Recommendation:** Consider extracting these sections

"@ | Out-File -FilePath $report -Append -Encoding UTF8
}

if ($lineCount -lt $warningThreshold) {
    @"
### [SUCCESS] Healthy

No critical issues found. CLAUDE.md is well-maintained.

"@ | Out-File -FilePath $report -Append -Encoding UTF8
}

# 6. Extraction recommendations
if ($largeSections.Count -gt 0 -or $lineCount -gt $warningThreshold) {
    @"

---

## Extraction Recommendations

"@ | Out-File -FilePath $report -Append -Encoding UTF8

    $gitWorkflow = $largeSections | Where-Object { $_ -match "Git Workflow" }
    if ($gitWorkflow) {
        @"
### Immediate Priority

**1. Git Workflow Section**
- **Current Size:** ~180 lines
- **Extract to:** `.claude/guides/workflows/git-workflow.md`
- **Reason:** Self-contained, frequently referenced
- **Effort:** 1 hour
- **Keep in CLAUDE.md:** Brief summary + link

"@ | Out-File -FilePath $report -Append -Encoding UTF8
    }

    $powershell = $largeSections | Where-Object { $_ -match "PowerShell" }
    if ($powershell) {
        @"
**2. PowerShell Script Guidelines**
- **Current Size:** ~70 lines
- **Extract to:** `.claude/guides/platform/powershell.md`
- **Reason:** Platform-specific, will grow with learnings
- **Effort:** 30 minutes
- **Keep in CLAUDE.md:** One-line reference

"@ | Out-File -FilePath $report -Append -Encoding UTF8
    }

    @"
### Future Extractions

When new large sections appear:
- Development workflows
- EDN format details
- Tool-specific guides
- Troubleshooting catalogs

"@ | Out-File -FilePath $report -Append -Encoding UTF8
}

# 7. Structure health
@"

---

## Structure Health

### Current Structure

"@ | Out-File -FilePath $report -Append -Encoding UTF8

Get-Content $claudeFile | Select-String -Pattern "^## " | ForEach-Object {
    $_.Line -replace '^## ', '- '
} | Out-File -FilePath $report -Append -Encoding UTF8

@"

### Recommended Structure (Future)

``````
CLAUDE.md (<400 lines)
├─ Project overview
├─ Quick navigation
├─ Core concepts (brief)
├─ Essential constraints
├─ Quick reference links
└─ Links to detailed guides

.claude/guides/
├─ platform/
│   ├─ powershell.md
│   ├─ bash.md
│   └─ cross-platform.md
├─ workflows/
│   ├─ git-workflow.md
│   ├─ development-workflow.md
│   └─ release-workflow.md
├─ tools/
│   ├─ edit-tool.md
│   ├─ bash-tool.md
│   └─ write-tool.md
└─ troubleshooting/
    ├─ common-errors.md
    ├─ encoding-issues.md
    └─ build-failures.md
``````

---

## Action Plan

"@ | Out-File -FilePath $report -Append -Encoding UTF8

if ($lineCount -gt $threshold) {
    @"
### Immediate (This Week)
- [ ] Extract Git Workflow section
- [ ] Extract PowerShell guidelines
- [ ] Update CLAUDE.md with links
- [ ] Test navigation
- [ ] Re-run health check

"@ | Out-File -FilePath $report -Append -Encoding UTF8
} elseif ($lineCount -gt $warningThreshold) {
    @"
### Soon (Next Month)
- [ ] Monitor growth
- [ ] Plan extractions
- [ ] Create .claude/guides/ structure
- [ ] Draft extraction documents

"@ | Out-File -FilePath $report -Append -Encoding UTF8
} else {
    @"
### Maintenance
- [ ] Monitor CLAUDE.md growth
- [ ] Re-check monthly
- [ ] Plan proactive extractions
- [ ] Keep documentation fresh

"@ | Out-File -FilePath $report -Append -Encoding UTF8
}

$nextReview = (Get-Date).AddDays(30).ToString("yyyy-MM-dd")

@"

---

## Estimated Effort

"@ | Out-File -FilePath $report -Append -Encoding UTF8

if ($largeSections.Count -gt 0) {
    @"
- Git Workflow extraction: 1 hour
- PowerShell extraction: 30 minutes
- Testing & validation: 30 minutes
- **Total:** 2 hours

"@ | Out-File -FilePath $report -Append -Encoding UTF8
} else {
    @"
No immediate extractions needed.

"@ | Out-File -FilePath $report -Append -Encoding UTF8
}

@"

---

## Recommendation

"@ | Out-File -FilePath $report -Append -Encoding UTF8

if ($lineCount -gt $threshold) {
    @"
**Status:** [ERROR] Extract large sections immediately

CLAUDE.md has exceeded the $threshold-line threshold. Extract large sections to maintain readability and navigability.

**Priority Actions:**
1. Extract Git Workflow (181 lines)
2. Extract PowerShell guidelines (68 lines)
3. Update cross-references
4. Re-run health check

"@ | Out-File -FilePath $report -Append -Encoding UTF8
} elseif ($lineCount -gt $warningThreshold) {
    @"
**Status:** [WARNING] Plan extraction, but not urgent yet

CLAUDE.md is approaching the $threshold-line threshold at $lineCount lines ($percent%).

**Recommended Actions:**
1. Monitor growth
2. Plan extractions when adding 50+ more lines
3. Extract if any section exceeds 100 lines

**Next Review:** After next major documentation addition

"@ | Out-File -FilePath $report -Append -Encoding UTF8
} else {
    @"
**Status:** [SUCCESS] Healthy and well-maintained

CLAUDE.md is at $lineCount lines ($percent% of $threshold-line threshold). Continue current maintenance.

**Recommended Actions:**
1. Continue monitoring
2. Keep sections concise
3. Link to detailed docs
4. Re-check monthly

**Next Review:** $nextReview

"@ | Out-File -FilePath $report -Append -Encoding UTF8
}

# Display summary
Write-Host ""
Write-Host "[SUCCESS] Analysis complete!"
Write-Host ""
Write-Host "Key findings:"

if ($lineCount -gt $threshold) {
    Write-Host "  [CRITICAL] Size exceeds threshold ($lineCount > $threshold)" -ForegroundColor Red
} elseif ($lineCount -gt $warningThreshold) {
    Write-Host "  [WARNING] Approaching threshold ($lineCount / $threshold)" -ForegroundColor Yellow
} else {
    Write-Host "  [HEALTHY] Well-maintained ($lineCount / $threshold)" -ForegroundColor Green
}

if ($largeSections.Count -gt 0) {
    Write-Host "  [WARNING] $($largeSections.Count) large sections found (>100 lines)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Report saved to: $report"
Write-Host ""

# Preview
Write-Host "Preview:"
Write-Host "======================================="
Get-Content $report | Select-Object -First 40
Write-Host "..."
Write-Host "======================================="
Write-Host ""
