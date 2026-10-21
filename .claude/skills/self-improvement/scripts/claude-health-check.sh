#!/bin/bash
# CLAUDE.md Health Check Script
# Part of self-improvement skill

set -e

# Configuration
CLAUDE_FILE="CLAUDE.md"
THRESHOLD=600
WARNING_THRESHOLD=550
OUTPUT_DIR=".claude/analysis"
TIMESTAMP=$(date +%Y-%m-%d)

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "======================================="
echo "  CLAUDE.md Health Check"
echo "======================================="
echo ""

# Check if CLAUDE.md exists
if [ ! -f "$CLAUDE_FILE" ]; then
    echo -e "${RED}ERROR: $CLAUDE_FILE not found${NC}"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Start report
REPORT="$OUTPUT_DIR/claude-health-$TIMESTAMP.md"

# 1. Measure file size
LINE_COUNT=$(wc -l < "$CLAUDE_FILE")
PERCENT=$(echo "scale=1; $LINE_COUNT * 100 / $THRESHOLD" | bc)

# Determine status
STATUS="🟢 Healthy"
STATUS_TEXT="Healthy"
if [ $LINE_COUNT -gt $THRESHOLD ]; then
    STATUS="🔴 Action Required"
    STATUS_TEXT="Action Required"
elif [ $LINE_COUNT -gt $WARNING_THRESHOLD ]; then
    STATUS="🟡 Needs Attention"
    STATUS_TEXT="Needs Attention"
fi

echo "Status: $STATUS_TEXT"
echo "Size: $LINE_COUNT / $THRESHOLD lines ($PERCENT%)"
echo ""

# 2. Count sections
SECTION_COUNT=$(grep -c "^## " "$CLAUDE_FILE")
echo "Sections: $SECTION_COUNT"

# 3. Find large sections
echo "Analyzing section sizes..."

# Get section lines
SECTIONS=$(grep -n "^## " "$CLAUDE_FILE")

# Calculate section sizes (approximate)
LARGE_SECTIONS=""
SECTION_SIZES=""

while IFS= read -r line; do
    SECTION_LINE=$(echo "$line" | cut -d: -f1)
    SECTION_NAME=$(echo "$line" | cut -d: -f2- | sed 's/^## //')

    # Find next section or end of file
    NEXT_SECTION=$(grep -n "^## " "$CLAUDE_FILE" | grep -A1 "^$SECTION_LINE:" | tail -1 | cut -d: -f1)

    if [ "$NEXT_SECTION" = "$SECTION_LINE" ]; then
        NEXT_SECTION=$LINE_COUNT
    fi

    SECTION_SIZE=$((NEXT_SECTION - SECTION_LINE))
    SECTION_SIZES="$SECTION_SIZES\n$SECTION_SIZE lines - $SECTION_NAME"

    if [ $SECTION_SIZE -gt 100 ]; then
        LARGE_SECTIONS="$LARGE_SECTIONS\n- **$SECTION_NAME** ($SECTION_SIZE lines, starts line $SECTION_LINE)"
    fi
done <<< "$SECTIONS"

# 4. Count links
INTERNAL_LINKS=$(grep -o '\[.*\](\..*\.md)' "$CLAUDE_FILE" | wc -l)
EXTERNAL_LINKS=$(grep -o '\[.*\](http.*\)' "$CLAUDE_FILE" | wc -l)

# 5. Check last modified
LAST_MODIFIED=$(git log -1 --format="%ad" --date=short -- "$CLAUDE_FILE" 2>/dev/null || echo "Unknown")

# Generate report
cat > "$REPORT" << EOF
# CLAUDE.md Health Check

**Date:** $TIMESTAMP
**Status:** $STATUS_TEXT

---

## Metrics

- **Size:** $LINE_COUNT lines (target: <$THRESHOLD)
- **Percentage:** $PERCENT% of threshold
- **Sections:** $SECTION_COUNT
- **Avg Section Length:** $(echo "$LINE_COUNT / $SECTION_COUNT" | bc) lines
- **Internal Links:** $INTERNAL_LINKS
- **External Links:** $EXTERNAL_LINKS
- **Last Updated:** $LAST_MODIFIED

---

## Section Sizes

$(echo -e "$SECTION_SIZES" | sort -rn)

---

## Issues Found

EOF

# Add issues based on status
if [ $LINE_COUNT -gt $THRESHOLD ]; then
    cat >> "$REPORT" << EOF
### 🔴 Critical

**File size exceeds threshold!**
- Current: $LINE_COUNT lines
- Threshold: $THRESHOLD lines
- Overage: $((LINE_COUNT - THRESHOLD)) lines

**Action Required:** Extract large sections immediately

EOF
fi

if [ -n "$LARGE_SECTIONS" ]; then
    cat >> "$REPORT" << EOF
### 🟡 Warnings

**Large Sections (>100 lines):**
$(echo -e "$LARGE_SECTIONS")

**Recommendation:** Consider extracting these sections

EOF
fi

if [ $LINE_COUNT -lt $WARNING_THRESHOLD ]; then
    cat >> "$REPORT" << EOF
### 🟢 Healthy

No critical issues found. CLAUDE.md is well-maintained.

EOF
fi

# 6. Extraction recommendations
if [ -n "$LARGE_SECTIONS" ] || [ $LINE_COUNT -gt $WARNING_THRESHOLD ]; then
    cat >> "$REPORT" << EOF

---

## Extraction Recommendations

EOF

    if echo -e "$LARGE_SECTIONS" | grep -q "Git Workflow"; then
        cat >> "$REPORT" << EOF
### Immediate Priority

**1. Git Workflow Section**
- **Current Size:** ~180 lines
- **Extract to:** \`.claude/guides/workflows/git-workflow.md\`
- **Reason:** Self-contained, frequently referenced
- **Effort:** 1 hour
- **Keep in CLAUDE.md:** Brief summary + link

EOF
    fi

    if echo -e "$LARGE_SECTIONS" | grep -q "PowerShell"; then
        cat >> "$REPORT" << EOF
**2. PowerShell Script Guidelines**
- **Current Size:** ~70 lines
- **Extract to:** \`.claude/guides/platform/powershell.md\`
- **Reason:** Platform-specific, will grow with learnings
- **Effort:** 30 minutes
- **Keep in CLAUDE.md:** One-line reference

EOF
    fi

    cat >> "$REPORT" << EOF
### Future Extractions

When new large sections appear:
- Development workflows
- EDN format details
- Tool-specific guides
- Troubleshooting catalogs

EOF
fi

# 7. Structure health
cat >> "$REPORT" << EOF

---

## Structure Health

### Current Structure
EOF

grep "^## " "$CLAUDE_FILE" | sed 's/^## /- /' >> "$REPORT"

cat >> "$REPORT" << EOF

### Recommended Structure (Future)

\`\`\`
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
\`\`\`

---

## Action Plan

EOF

if [ $LINE_COUNT -gt $THRESHOLD ]; then
    cat >> "$REPORT" << EOF
### Immediate (This Week)
- [ ] Extract Git Workflow section
- [ ] Extract PowerShell guidelines
- [ ] Update CLAUDE.md with links
- [ ] Test navigation
- [ ] Re-run health check

EOF
elif [ $LINE_COUNT -gt $WARNING_THRESHOLD ]; then
    cat >> "$REPORT" << EOF
### Soon (Next Month)
- [ ] Monitor growth
- [ ] Plan extractions
- [ ] Create .claude/guides/ structure
- [ ] Draft extraction documents

EOF
else
    cat >> "$REPORT" << EOF
### Maintenance
- [ ] Monitor CLAUDE.md growth
- [ ] Re-check monthly
- [ ] Plan proactive extractions
- [ ] Keep documentation fresh

EOF
fi

cat >> "$REPORT" << EOF

---

## Estimated Effort

EOF

if [ -n "$LARGE_SECTIONS" ]; then
    cat >> "$REPORT" << EOF
- Git Workflow extraction: 1 hour
- PowerShell extraction: 30 minutes
- Testing & validation: 30 minutes
- **Total:** 2 hours

EOF
else
    cat >> "$REPORT" << EOF
No immediate extractions needed.

EOF
fi

cat >> "$REPORT" << EOF

---

## Recommendation

EOF

if [ $LINE_COUNT -gt $THRESHOLD ]; then
    cat >> "$REPORT" << EOF
**Status:** 🔴 Extract large sections immediately

CLAUDE.md has exceeded the $THRESHOLD-line threshold. Extract large sections to maintain readability and navigability.

**Priority Actions:**
1. Extract Git Workflow (181 lines)
2. Extract PowerShell guidelines (68 lines)
3. Update cross-references
4. Re-run health check

EOF
elif [ $LINE_COUNT -gt $WARNING_THRESHOLD ]; then
    cat >> "$REPORT" << EOF
**Status:** 🟡 Plan extraction, but not urgent yet

CLAUDE.md is approaching the $THRESHOLD-line threshold at $LINE_COUNT lines ($PERCENT%).

**Recommended Actions:**
1. Monitor growth
2. Plan extractions when adding 50+ more lines
3. Extract if any section exceeds 100 lines

**Next Review:** After next major documentation addition

EOF
else
    cat >> "$REPORT" << EOF
**Status:** 🟢 Healthy and well-maintained

CLAUDE.md is at $LINE_COUNT lines ($PERCENT% of $THRESHOLD-line threshold). Continue current maintenance.

**Recommended Actions:**
1. Continue monitoring
2. Keep sections concise
3. Link to detailed docs
4. Re-check monthly

**Next Review:** $(date -d '+30 days' +%Y-%m-%d)

EOF
fi

# Display summary
echo ""
echo "Analysis complete!"
echo ""
echo "Key findings:"
if [ $LINE_COUNT -gt $THRESHOLD ]; then
    echo -e "  ${RED}[CRITICAL]${NC} Size exceeds threshold ($LINE_COUNT > $THRESHOLD)"
elif [ $LINE_COUNT -gt $WARNING_THRESHOLD ]; then
    echo -e "  ${YELLOW}[WARNING]${NC} Approaching threshold ($LINE_COUNT / $THRESHOLD)"
else
    echo -e "  ${GREEN}[HEALTHY]${NC} Well-maintained ($LINE_COUNT / $THRESHOLD)"
fi

if [ -n "$LARGE_SECTIONS" ]; then
    echo -e "  ${YELLOW}[WARNING]${NC} $(echo -e "$LARGE_SECTIONS" | grep -c "^-") large sections found (>100 lines)"
fi

echo ""
echo "Report saved to: $REPORT"
echo ""

# Preview
echo "Preview:"
echo "======================================="
head -n 40 "$REPORT"
echo "..."
echo "======================================="
echo ""
