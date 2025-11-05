#!/bin/bash

# Logseq Template Analysis Script
# Shows structure and finds specific classes/properties

FILE="${1:-logseq_db_Templates.edn}"
SEARCH="${2}"

if [ ! -f "$FILE" ]; then
    echo "Error: File not found: $FILE"
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Logseq Template Structure Analysis"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Overall stats
TOTAL_LINES=$(wc -l < "$FILE")
PROP_COUNT=$(grep -c "user.property/" "$FILE")
CLASS_COUNT=$(grep -c "user.class/" "$FILE")

echo "📊 Overall Statistics"
echo "  Total lines: $TOTAL_LINES"
echo "  Properties:  $PROP_COUNT"
echo "  Classes:     $CLASS_COUNT"
echo ""

# List all classes with line numbers
echo "📦 Classes (with line numbers)"
grep -n "user.class/" "$FILE" | cut -d: -f1,2 | sed 's/:/ → /' | head -20

echo ""

# If search term provided
if [ -n "$SEARCH" ]; then
    echo "🔍 Searching for: $SEARCH"
    grep -n -i "$SEARCH" "$FILE" | head -20
    echo ""
fi

# Section boundaries
echo "📍 Main Sections"
grep -n "^ :properties" "$FILE" | sed 's/:/ → Properties start at line /'
grep -n "^ :classes" "$FILE" | sed 's/:/ → Classes start at line /'
grep -n "logseq.db.sqlite.export" "$FILE" | sed 's/:/ → Export marker at line /'
echo ""

echo "💡 Usage:"
echo "  View specific class:    $0 $FILE Person"
echo "  View specific property: $0 $FILE email"
echo "  Jump to line:           vim +1130 $FILE"
