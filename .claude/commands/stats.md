# Project Statistics Dashboard

Display comprehensive statistics about the Logseq Template Graph project.

Quick overview of classes, properties, modules, builds, and recent changes.

## What This Does

Shows:
1. **Project Overview** - Total classes, properties, lines
2. **Module Breakdown** - Classes and properties per module
3. **Variant Sizes** - Build sizes for all 5 templates
4. **Recent Changes** - What changed in last commit
5. **Growth Trends** - Historical growth (if available)
6. **Health Metrics** - Module balance, coverage, issues

## Usage

```
/stats [options]
```

**Options:**
```bash
/stats                 # Full dashboard
/stats --modules       # Modules only
/stats --variants      # Build variants only
/stats --recent        # Recent changes only
/stats --trends        # Growth trends
/stats --health        # Health metrics
```

## Full Dashboard Output

```
📊 Logseq Template Graph - Project Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎯 Overview
  Template Size: 15,422 lines (monolith)
  Total Classes: 632
  Total Properties: 1,033
  Source Modules: 11
  Template Variants: 5
  Last Updated: 2025-11-08 14:32:15

📁 Module Breakdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Module           Classes  Properties  Size (lines)  Status
  ──────────────────────────────────────────────────────────────
  base/                 2           0           45   ✅
  person/               2          36          412   ✅
  organization/         4          15          285   ✅
  event/               17           6          623   ✅
  creative-work/       14           7          485   ✅
  place/                2           9          178   ✅
  product/              1           2           67   ✅
  intangible/           9           9          342   ✅
  action/               1           1           52   ✅
  health/               8          12          298   ✅
  misc/                82          59        1,847   ⚠️  LARGE
  common/               0         189          876   ✅ (shared)
  ──────────────────────────────────────────────────────────────
  TOTAL               142         345        5,510

  ⚠️  Note: misc/ contains 58% of classes (consider splitting)

🎨 Template Variants
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Variant    Lines   Classes  Properties  Size (KB)  Last Built
  ───────────────────────────────────────────────────────────────
  full       8,934       135         334       498   2 hours ago
  crm        5,389         8         240       298   2 hours ago
  research   4,203        45         180       235   2 hours ago
  content    3,902        40         150       220   2 hours ago
  events     2,801        25         120       156   2 hours ago

  Coverage: 100% of classes appear in at least one variant ✅

📈 Recent Changes (last commit)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Commit: feat(classes): add Recipe class (abc1234)
  Date: 2025-11-08 12:15:00
  Author: John Doe <john@example.com>

  Changes:
    + 1 class (Recipe)
    + 6 properties (recipeIngredient, cookTime, etc.)
    + 25 lines to full variant
    + 25 lines to content variant

  Files modified:
    source/creative-work/classes.edn (+12)
    source/creative-work/properties.edn (+13)

🔥 Growth Trends (last 30 days)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Classes:     620 → 632 (+12, +1.9%)
  Properties: 1,015 → 1,033 (+18, +1.8%)
  Lines:     15,103 → 15,422 (+319, +2.1%)

  Average per week:
    Classes: +3 per week
    Properties: +4.5 per week

  Most active modules:
    1. creative-work (+5 classes)
    2. health (+3 classes)
    3. person (+4 properties)

📊 Health Metrics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✅ Module balance: 8/11 modules well-sized
  ⚠️  misc/ module: 82 classes (58% of total)
     → Consider: Split into sub-modules

  ✅ Property reuse: 189 common properties (18% of total)
     → Good architecture

  ✅ Class hierarchy: 95% of classes have parents
     → 5% orphaned (Schedule, ProductCategory, etc.)

  ✅ Build health: All 5 variants building successfully
  ✅ Validation: No EDN syntax errors
  ✅ Documentation: Up to date

  Overall Health Score: 87/100 (Good) ✅

🔗 Quick Links
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Commands:
    /new-class          - Add new class
    /new-property       - Add new property
    /test-workflow      - Test changes
    /release-prep       - Prepare release

  Documentation:
    QUICK_START.md      - Getting started
    docs/modular/       - Modular workflow
    docs/architecture/  - Technical details

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Generated: 2025-11-08 14:32:15 | Refresh: /stats
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Focused Views

### Modules Only

```
/stats --modules

📁 Module Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Module Breakdown:

  base/
    Classes: 2 (Thing, root hierarchy)
    Properties: 0
    Size: 45 lines
    Status: ✅ Core module

  person/
    Classes: 2 (Person, Patient)
    Properties: 36
    Size: 412 lines
    Avg properties per class: 18
    Status: ✅ Well-balanced

  organization/
    Classes: 4 (Organization, Corporation, EducationalOrganization, NGO)
    Properties: 15
    Size: 285 lines
    Avg properties per class: 3.75
    Status: ✅ Well-balanced

  event/
    Classes: 17 (Event, BusinessMeeting, Conference, etc.)
    Properties: 6
    Size: 623 lines
    Avg properties per class: 0.35
    Status: ⚠️  Many classes, few properties

  creative-work/
    Classes: 14 (CreativeWork, Article, Book, Recipe, etc.)
    Properties: 7
    Size: 485 lines
    Status: ✅ Good diversity

  place/
    Classes: 2 (Place, LocalBusiness)
    Properties: 9
    Size: 178 lines
    Status: ✅ Well-balanced

  product/
    Classes: 1 (Product)
    Properties: 2
    Size: 67 lines
    Status: ✅ Small but focused

  intangible/
    Classes: 9 (Rating, Schedule, Offer, etc.)
    Properties: 9
    Size: 342 lines
    Status: ✅ Well-balanced

  action/
    Classes: 1 (Action)
    Properties: 1
    Size: 52 lines
    Status: ✅ Core module

  health/
    Classes: 8 (MedicalCondition, Drug, Therapy, etc.)
    Properties: 12
    Size: 298 lines
    Status: ✅ Specialized domain

  misc/
    Classes: 82 (mixed types)
    Properties: 59
    Size: 1,847 lines
    Status: ⚠️  BLOATED - 58% of all classes
    Recommendation: Split into focused modules

  common/
    Classes: 0
    Properties: 189 (shared across modules)
    Size: 876 lines
    Status: ✅ Good reuse pattern

Totals:
  11 modules
  142 unique classes (632 with inheritance)
  345 module-specific properties (1,033 total with common)
```

### Variants Only

```
/stats --variants

🎨 Template Variant Statistics
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

full (Complete Template)
  Purpose: All classes and properties
  Lines: 8,934
  Classes: 135
  Properties: 334
  Size: 498 KB
  Modules included: ALL
  Last built: 2 hours ago
  Status: ✅ Building successfully

crm (Customer Relationship Management)
  Purpose: People, organizations, contacts
  Lines: 5,389
  Classes: 8
  Properties: 240
  Size: 298 KB
  Modules included: person, organization, common
  Last built: 2 hours ago
  Status: ✅ Building successfully

research (Research & Academia)
  Purpose: Academic research, publications
  Lines: 4,203
  Classes: 45
  Properties: 180
  Size: 235 KB
  Modules included: person, organization, creative-work, common
  Last built: 2 hours ago
  Status: ✅ Building successfully

content (Content Management)
  Purpose: Articles, blogs, media
  Lines: 3,902
  Classes: 40
  Properties: 150
  Size: 220 KB
  Modules included: creative-work, person, common
  Last built: 2 hours ago
  Status: ✅ Building successfully

events (Event Management)
  Purpose: Conferences, meetings, schedules
  Lines: 2,801
  Classes: 25
  Properties: 120
  Size: 156 KB
  Modules included: event, person, place, common
  Last built: 2 hours ago
  Status: ✅ Building successfully

Comparison:
  Largest: full (8,934 lines, 498 KB)
  Smallest: events (2,801 lines, 156 KB)
  Ratio: 3.2:1 (largest vs smallest)

Build Performance:
  Average build time: ~5-10 seconds
  Total build time (all 5): ~30-40 seconds
  Parallelizable: Yes (with Babashka)
```

### Recent Changes Only

```
/stats --recent

📈 Recent Changes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Last 5 Commits:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. feat(classes): add Recipe class
   Date: 2025-11-08 12:15:00
   Author: John Doe
   Changes:
     + 1 class
     + 6 properties
     + 25 lines (full, content)
   Files: source/creative-work/

2. feat(properties): add jobTitle to Person
   Date: 2025-11-07 16:42:00
   Author: Jane Smith
   Changes:
     + 1 property
     + 5 lines (full, crm)
   Files: source/person/

3. fix(templates): correct spouse cardinality
   Date: 2025-11-07 10:30:00
   Author: John Doe
   Changes:
     ~ Modified 1 property (cardinality :many → :one)
     No line count change
   Files: source/person/properties.edn

4. feat(classes): add Book and Article classes
   Date: 2025-11-06 14:20:00
   Author: Jane Smith
   Changes:
     + 2 classes
     + 8 properties
     + 45 lines (full, content, research)
   Files: source/creative-work/

5. chore(deps): update dependencies
   Date: 2025-11-05 09:15:00
   Author: CI/CD Bot
   Changes:
     Sync from Logseq
   Files: Multiple

Summary (last 7 days):
  Commits: 12
  Features: 8
  Fixes: 2
  Chores: 2
  Classes added: 5
  Properties added: 18
  Total lines: +95

Most Active:
  Author: Jane Smith (7 commits)
  Module: creative-work (4 commits)
  Day: Wednesday (5 commits)
```

### Growth Trends

```
/stats --trends

🔥 Growth Trends
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Historical Growth (Last 90 Days):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Classes:
  Aug 8:  580
  Sep 8:  602 (+22, +3.8%)
  Oct 8:  618 (+16, +2.7%)
  Nov 8:  632 (+14, +2.3%)

  Total growth: +52 classes (+9.0%)
  Average: +0.58 classes/day

Properties:
  Aug 8:  945
  Sep 8:  978 (+33, +3.5%)
  Oct 8: 1,005 (+27, +2.8%)
  Nov 8: 1,033 (+28, +2.8%)

  Total growth: +88 properties (+9.3%)
  Average: +0.98 properties/day

Template Size (full variant):
  Aug 8: 8,123 lines
  Sep 8: 8,456 lines (+333, +4.1%)
  Oct 8: 8,712 lines (+256, +3.0%)
  Nov 8: 8,934 lines (+222, +2.5%)

  Total growth: +811 lines (+10.0%)
  Average: +9.0 lines/day

Growth Rate Trend:
  Classes: Steady (±3% per month)
  Properties: Steady (±3% per month)
  Lines: Slowing (4% → 2.5% per month)
  → Indicates: Refactoring/cleanup phase

Projections (next 30 days):
  Classes: ~645 (+13, +2%)
  Properties: ~1,062 (+29, +3%)
  Lines: ~9,156 (+222, +2.5%)

Module Activity (last 90 days):
  creative-work: +12 classes, +25 properties
  health: +8 classes, +18 properties
  person: +2 classes, +15 properties
  event: +5 classes, +8 properties
  misc: +25 classes, +22 properties (BLOAT)
```

### Health Metrics

```
/stats --health

📊 Project Health Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Module Balance: 72/100 ⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Well-balanced modules (8/11):
    ✅ person (2 classes, 36 properties)
    ✅ organization (4 classes, 15 properties)
    ✅ creative-work (14 classes, 7 properties)
    ✅ place (2 classes, 9 properties)
    ✅ product (1 class, 2 properties)
    ✅ intangible (9 classes, 9 properties)
    ✅ action (1 class, 1 property)
    ✅ health (8 classes, 12 properties)

  Attention needed (3/11):
    ⚠️  event (17 classes, only 6 properties)
       → Many classes with minimal properties

    ⚠️  misc (82 classes, 58% of total)
       → BLOATED: Consider splitting into:
          - communication/ (EmailMessage, Message)
          - financial/ (Invoice, PaymentCard, Order)
          - schema-types/ (DataType, StructuredValue)
          - administrative/ (Permit, Government, etc.)

    ⚠️  base (core classes, minimal properties)
       → OK for core module

Property Reuse: 95/100 ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Common properties: 189 (18% of total)
  Shared across: 8+ modules
  Examples: name, description, identifier, url

  Most reused properties:
    - name (used by 95% of classes)
    - description (used by 87% of classes)
    - identifier (used by 65% of classes)
    - url (used by 52% of classes)

  Property utilization: Excellent ✅

Class Hierarchy: 85/100 ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Classes with parents: 601/632 (95%)
  Orphaned classes: 31 (5%)
    - Schedule (should inherit from Intangible)
    - ProductCategory (should inherit from Thing)
    - [29 more...]

  Hierarchy depth:
    Max depth: 4 levels (Thing → CreativeWork → Article → NewsArticle)
    Avg depth: 2.3 levels
    Recommendation: Good depth ✅

Build Health: 100/100 ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  All 5 variants building: ✅
  No EDN syntax errors: ✅
  No validation warnings: ✅
  No duplicate IDs: ✅
  All parent classes exist: ✅

Documentation: 90/100 ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  README.md: Up to date ✅
  QUICK_START.md: Up to date ✅
  Module READMEs: 11/11 present ✅
  Technical docs: Up to date ✅
  CLAUDE.md: Up to date ✅

  Suggested improvements:
    - Add examples for new classes (Recipe, Book)
    - Update architecture diagram with new modules
    - Document health/ module specializations

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall Health Score: 87/100 (Good) ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Recommendations:
  1. Split misc/ module into 4-5 focused modules
  2. Add parents to 31 orphaned classes
  3. Add more properties to event/ module classes
  4. Update documentation with recent examples
```

---

## Data Sources

The command gathers statistics from:

1. **Source Modules** - `source/*/` directories
2. **Build Artifacts** - `build/` directory
3. **Git History** - Recent commits, growth trends
4. **Validation Scripts** - Health metrics
5. **Archive** - Historical snapshots (if available)

---

## Export Options

### Export to File

```
/stats --export stats.txt

Statistics exported to: stats.txt

Use for:
  - Documentation
  - Reports
  - Historical tracking
```

### Export as JSON

```
/stats --json > stats.json

Exports machine-readable JSON:
{
  "overview": {
    "classes": 632,
    "properties": 1033,
    "lines": 15422
  },
  "modules": [...],
  "variants": [...],
  "recent": [...],
  "trends": {...},
  "health": {...}
}
```

### Export as Markdown

```
/stats --markdown > STATS.md

Creates formatted Markdown report suitable for documentation.
```

---

## Tips

- **Run regularly** - Track project health monthly
- **Before releases** - Verify metrics before tagging
- **After major changes** - Check impact on variants
- **Share with team** - Include in status reports
- **Track trends** - Export JSON for historical analysis

---

## Time Savings

**Manual Statistics Collection:**
1. Count classes manually (10 min)
2. Count properties manually (10 min)
3. Check each variant (5 min)
4. Review recent commits (5 min)
5. Calculate growth (10 min)
6. Assess health manually (15 min)
**Total: ~55 minutes**

**With /stats:**
1. Run command
2. Review output
**Total: ~2 minutes**

**Saves: 53 minutes (96% reduction)**

---

## Related Commands

- `/test-workflow` - Test complete workflow
- `/new-class` - Add new class
- `/new-property` - Add new property
- `/release-prep` - Prepare release
- `/validate-env` - Check environment

---

## Learn More

- [Project Overview](../../README.md)
- [Architecture](../../docs/architecture/technical-reference.md)
- [CI/CD Pipeline](../../docs/developer-guide/ci-cd-pipeline.md)
