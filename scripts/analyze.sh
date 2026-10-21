#!/bin/bash
# Quick structure analysis for a source/ module file or a built library.
# Usage: scripts/analyze.sh [file] [search-term]
#   file defaults to build/schema-library.edn (run `bb build` first)

FILE="${1:-build/schema-library.edn}"
SEARCH="${2}"

if [ ! -f "$FILE" ]; then
    echo "Error: File not found: $FILE"
    exit 1
fi

# Top-level class/property keys sit at one or two spaces of indent;
# class-properties vectors are indented further, so they are not counted.
CLASS_KEY='^ {1,2}\{?:(schema|custom)\.class/'
PROP_KEY='^ {1,2}\{?:(schema|custom)\.property/'

echo "Structure analysis: $FILE"
echo "  Total lines: $(wc -l < "$FILE")"
echo "  Classes:     $(grep -cE "$CLASS_KEY" "$FILE")"
echo "  Properties:  $(grep -cE "$PROP_KEY" "$FILE")"
echo "  Custom:      $(grep -cE '^ {1,2}\{?:custom\.(class|property)/' "$FILE")"
echo ""

echo "Classes (first 20, with line numbers)"
grep -nE "$CLASS_KEY" "$FILE" | head -20 | sed 's/:/ -> /'
echo ""

if [ -n "$SEARCH" ]; then
    echo "Searching for: $SEARCH"
    grep -n -i "$SEARCH" "$FILE" | head -20
    echo ""
fi

echo "Usage:"
echo "  $0 build/schema-library.edn Person"
echo "  $0 source/person/classes.edn"
