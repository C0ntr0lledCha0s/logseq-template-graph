# Performance Monitoring Command

Monitor and analyze build performance, workflow efficiency, and project health metrics over time.

## What This Does

This command provides comprehensive performance monitoring for the template development workflow:
- Build time trends
- Template size growth
- Workflow efficiency metrics
- CI/CD pipeline performance
- Development velocity
- Quality metrics

## Analysis Areas

### 1. Build Performance

**Metrics:**
- Template build times (full, variants)
- Export times
- Validation times
- Total workflow time

**Analysis:**
```bash
# Time recent builds
time bb build

# Check git history for build time changes
git log --grep="build" --oneline -10
```

**Report:**
```
⚡ Build Performance Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Build Times (avg of 3 runs):
┌──────────────┬──────────┬────────────┬──────────┐
│ Variant      │ Time     │ Size       │ Speed    │
├──────────────┼──────────┼────────────┼──────────┤
│ full         │ 2.3s     │ 497 KB     │ 216 KB/s │
│ crm          │ 0.8s     │ 298 KB     │ 373 KB/s │
│ research     │ 0.9s     │ 317 KB     │ 352 KB/s │
│ content      │ 0.7s     │ 285 KB     │ 407 KB/s │
│ events       │ 0.8s     │ 302 KB     │ 378 KB/s │
└──────────────┴──────────┴────────────┴──────────┘

📈 Trend (last 30 days):
  Full build: 2.1s → 2.3s (+9.5%)
  Reason: +15 classes, +28 properties

⚠️  Warnings:
  - Build time increasing (growth expected)
  - Consider splitting large modules if > 5s
```

### 2. Template Growth

**Metrics:**
- Total classes over time
- Total properties over time
- File size growth
- Module count changes

**Analysis:**
```bash
# Get current stats
grep -c ":schema.class/" build/schema-library.edn
grep -c ":schema.property/" build/schema-library.edn
ls -lh build/schema-library.edn

# Historical data from git
git log --all --oneline --stat -- "*.edn"
```

**Report:**
```
📊 Template Growth Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Size (Nov 2025):
  Classes: 632
  Properties: 1,033
  File size: 497 KB
  Lines: 15,422

Growth Rate (30 days):
  Classes: +15 (+2.4%)
  Properties: +28 (+2.8%)
  File size: +22 KB (+4.6%)

Growth Rate (90 days):
  Classes: +47 (+8.0%)
  Properties: +89 (+9.4%)
  File size: +68 KB (+15.9%)

Projection (next 90 days):
  Classes: ~680 (at current rate)
  Properties: ~1,120
  File size: ~565 KB

📈 Growth Trend: Healthy
  - Steady, controlled growth
  - Properties growing faster than classes (good detail)
  - File size growth proportional
```

### 3. Workflow Efficiency

**Metrics:**
- Time from change to commit
- Time from commit to release
- Manual vs automated tasks
- Command usage frequency

**Analysis:**
```bash
# Analyze commit timestamps
git log --pretty=format:"%ai %s" -20

# Check command usage (if logging implemented)
# grep "/new-class" .claude/logs/*
```

**Report:**
```
🚀 Workflow Efficiency Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Average Times:
  Export → Commit: 5 min (down from 15 min) ✅ -67%
  Commit → Release: 12 min (down from 30 min) ✅ -60%
  New class workflow: 8 min (down from 25 min) ✅ -68%

Command Usage (last 7 days):
  /export: 12 times
  /new-class: 5 times
  /new-property: 8 times
  /stats: 3 times
  /test-workflow: 7 times

Time Saved (last 30 days):
  Manual tasks: ~12 hours
  Automation: ~45 minutes
  Net savings: ~11.25 hours

ROI: 1,500% (time saved vs setup time)
```

### 4. CI/CD Performance

**Metrics:**
- GitHub Actions run times
- Success/failure rates
- Build frequency
- Release frequency

**Analysis:**
```bash
# Check recent workflow runs
gh run list --limit 20

# Analyze workflow file
cat .github/workflows/build-templates.yml
cat .github/workflows/release.yml
```

**Report:**
```
🔄 CI/CD Performance
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Pipeline Success Rate (30 days):
  Build workflow: 95% (38/40 runs)
  Release workflow: 100% (5/5 runs)
  Overall: 96% (43/45 runs)

Average Run Times:
  Build workflow: 2m 15s
  Release workflow: 3m 45s
  Total CI time: ~2h 30m (30 days)

Recent Failures (2):
  1. Nov 5: Node version mismatch ✓ Fixed
  2. Nov 2: Validation error ✓ Fixed

Build Frequency:
  Daily: 1.3 builds/day
  Weekly: 9 builds/week
  Monthly: 40 builds/month

Release Frequency:
  Last release: 5 days ago
  Average: 1 release/week
  Total releases: 12 (last 90 days)
```

### 5. Development Velocity

**Metrics:**
- Commits per week
- Features added per month
- Issues closed per month
- Time to merge

**Analysis:**
```bash
# Recent activity
git log --oneline --since="30 days ago" | wc -l
git log --oneline --since="90 days ago" | wc -l

# Commit breakdown
git log --oneline --since="30 days ago" --grep="feat"
git log --oneline --since="30 days ago" --grep="fix"
```

**Report:**
```
📈 Development Velocity
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Activity (last 30 days):
  Commits: 47
  Features: 15 (32%)
  Fixes: 8 (17%)
  Docs: 12 (26%)
  Chores: 12 (26%)

Activity (last 90 days):
  Commits: 156
  Features: 52 (33%)
  Fixes: 23 (15%)
  Docs: 42 (27%)
  Chores: 39 (25%)

Velocity Trend:
  Commits/week: 10.9 (↑ from 8.7)
  Features/week: 3.5 (↑ from 2.9)

Most Active Areas:
  1. classes (28 commits)
  2. properties (22 commits)
  3. docs (18 commits)
  4. ci (12 commits)
```

### 6. Quality Metrics

**Metrics:**
- Validation pass rate
- Test coverage
- Documentation coverage
- Issue resolution time

**Analysis:**
```bash
# Check validation
bb validate

# Check docs coverage
find docs -name "*.md" | wc -l
find source -name "README.md" | wc -l
```

**Report:**
```
✅ Quality Metrics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Validation:
  Build artifacts: 100% pass (5/5 variants)
  Source modules: 100% valid (11/11 modules)
  EDN syntax: 0 errors

Documentation:
  Module READMEs: 91% (10/11 modules)
  Missing: misc/README.md

  Docs coverage:
    User guides: 3 docs
    Developer guides: 2 docs
    Architecture: 1 doc
    Research: 1 doc
    Total: 7 documentation files

Code Quality:
  Conventional commits: 94% (last 30 commits)
  Orphaned classes: 2 (0.3%)
  Orphaned properties: 5 (0.5%)

Health Score: 87/100
```

## Interactive Mode

### Quick Check
```
User: /performance

You:
Running quick performance check...

✅ Current Status:
  Build time: 2.3s (full template)
  Template size: 497 KB, 632 classes, 1,033 properties
  Last build: 2 hours ago
  Health score: 87/100

Recent activity:
  - 5 commits in last 7 days
  - 2 new classes added
  - 1 release published

💡 Everything looks good!

Would you like to see:
  a) Full performance report
  b) Build time trends
  c) Development velocity
  d) Quality metrics
```

### Full Report
```
User: /performance --full

You:
Generating comprehensive performance report...

[Run all analyses]
[Generate all sections]
[Save to file]

📊 Performance Report Generated
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Saved to: reports/performance-2025-11-08.md

Highlights:
  ✅ Build performance: Excellent
  ✅ Growth rate: Healthy
  ✅ Workflow efficiency: 67% faster
  ⚠️  CI success rate: 96% (2 recent failures)
  ✅ Development velocity: Increasing
  ✅ Quality metrics: 87/100

[Show executive summary]
```

### Trend Analysis
```
User: /performance --trend

You:
Analyzing trends over last 90 days...

📈 Key Trends
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Positive Trends:
  ✅ Build time stable (±5%)
  ✅ Workflow 67% faster (automation working!)
  ✅ Commit velocity up 25%
  ✅ Documentation growing

Areas to Watch:
  ⚠️  Template size growing 16% (expected)
  ⚠️  CI runs increasing (more activity)

Recommendations:
  1. Monitor build time as template grows
  2. Consider splitting misc/ module
  3. Add more test coverage
```

### Specific Metric
```
User: /performance --builds

You:
⚡ Build Performance Details
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Show detailed build metrics]
[Include historical data]
[Show optimization suggestions]
```

## Output Options

### Console Output
Default: Show in terminal with colors and emojis

### Markdown Report
```bash
# Save to file
/performance --output=reports/performance-2025-11-08.md
```

### JSON Export
```bash
# Export data for analysis
/performance --json=reports/performance-2025-11-08.json
```

### Chart/Graph
```
# Generate ASCII chart for trends
/performance --chart
```

## Implementation

### Data Collection
```bash
# Build times
time bb build 2>&1 | grep real

# Template stats
grep -c ":schema.class/" build/*.edn
grep -c ":schema.property/" build/*.edn
ls -lh build/*.edn

# Git metrics
git log --oneline --since="30 days ago"
git log --pretty=format:"%ai" --since="30 days ago"

# CI metrics (if gh CLI available)
gh run list --limit 50 --json status,conclusion,createdAt
```

### Trend Calculation
```bash
# Compare with 30 days ago
git show HEAD~30:build/schema-library.edn | grep -c ":schema.class/"

# Growth rate
current=632
previous=617
growth=$((current - previous))
percentage=$((growth * 100 / previous))
```

### Visualization
Use ASCII tables, bar charts, and trend indicators:
- ↑ Increasing
- ↓ Decreasing
- → Stable
- ✅ Good
- ⚠️  Warning
- ❌ Critical

## Success Criteria

- Accurate performance metrics
- Clear trend visualization
- Actionable insights
- Historical comparisons
- Export options
- Fast execution (< 30s for full report)
- Regular monitoring enabled

## Tools to Use

- **Bash**: Run analysis commands, time builds, git operations
- **Read**: Read template files for stats
- **Grep**: Count patterns, search logs
- **Write**: Save reports to files

## Notes

- Cache results to avoid re-running expensive operations
- Compare with baselines
- Show trends, not just current values
- Provide context and interpretation
- Suggest optimizations when issues detected
- Make it easy to run regularly (weekly/monthly)

---

**This command provides comprehensive performance visibility for continuous improvement of the development workflow.**
