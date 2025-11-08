#!/bin/bash

# Logseq Template Graph Export Script
# This script exports your development graph to clean, version-controlled EDN files

set -e  # Exit on error

# Configuration
GRAPH_PATH="${LOGSEQ_GRAPH_PATH:-$HOME/logseq/graphs/Test Build}"
OUTPUT_DIR="${LOGSEQ_OUTPUT_DIR:-archive/pre-modular}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}🚀 Exporting Logseq Template Graph...${NC}"
echo -e "${YELLOW}Graph: ${GRAPH_PATH}${NC}"
echo ""

# Check if Logseq CLI is available
if ! command -v npx &> /dev/null; then
    echo -e "${RED}❌ Error: npx not found (Node.js required)${NC}"
    echo -e "${YELLOW}Install Node.js from: https://nodejs.org${NC}"
    exit 1
fi

# Check if graph directory exists
if [ ! -d "$GRAPH_PATH" ]; then
    echo -e "${RED}❌ Error: Graph directory not found: $GRAPH_PATH${NC}"
    echo -e "${YELLOW}Set LOGSEQ_GRAPH_PATH environment variable or edit this script${NC}"
    exit 1
fi

# Get absolute path for output directory
if [ "$OUTPUT_DIR" = "." ]; then
    OUTPUT_DIR_ABS="$(pwd)"
elif [ -d "$OUTPUT_DIR" ]; then
    OUTPUT_DIR_ABS="$(cd "$OUTPUT_DIR" && pwd)"
else
    # Handle relative paths that don't exist yet
    OUTPUT_DIR_ABS="$(pwd)/$OUTPUT_DIR"
    # Create directory if it doesn't exist
    if [ ! -d "$OUTPUT_DIR_ABS" ]; then
        mkdir -p "$OUTPUT_DIR_ABS"
        echo -e "${GREEN}Created output directory: $OUTPUT_DIR_ABS${NC}"
    fi
fi

echo -e "${CYAN}Output directory: $OUTPUT_DIR_ABS${NC}"
echo ""

# Export template (clean, no timestamps)
echo -e "${YELLOW}📦 Exporting template...${NC}"
OUTPUT_FILE="$OUTPUT_DIR_ABS/logseq_db_Templates.edn"
echo -e "${CYAN}Target file: $OUTPUT_FILE${NC}"
npx logseq export-edn \
  "$GRAPH_PATH" \
  --file "$OUTPUT_FILE" \
  --exclude-built-in-pages \
  --exclude-namespaces "logseq.kv"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Template exported${NC}"
else
    echo -e "${RED}❌ Failed to export template${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Export complete!${NC}"
echo ""

# Show statistics
TEMPLATE_FILE="$OUTPUT_DIR_ABS/logseq_db_Templates.edn"
if command -v wc &> /dev/null && [ -f "$TEMPLATE_FILE" ]; then
    LINES=$(wc -l < "$TEMPLATE_FILE")
    echo -e "${CYAN}📊 Statistics:${NC}"
    echo -e "   Lines: ${LINES}"
fi

if command -v grep &> /dev/null && [ -f "$TEMPLATE_FILE" ]; then
    PROP_COUNT=$(grep -c "user.property/" "$TEMPLATE_FILE" || echo "0")
    CLASS_COUNT=$(grep -c "user.class/" "$TEMPLATE_FILE" || echo "0")
    echo -e "   Properties: ${PROP_COUNT}"
    echo -e "   Classes: ${CLASS_COUNT}"
fi

echo ""

# Show git changes
if command -v git &> /dev/null && [ -d .git ]; then
    echo -e "${CYAN}📊 Git changes:${NC}"
    git diff --stat archive/pre-modular/logseq_db_Templates.edn 2>/dev/null || echo "   No changes detected"
    echo ""
fi

echo ""
echo -e "${YELLOW}📦 Splitting template into modules...${NC}"

# Check if babashka is available
if command -v bb &> /dev/null; then
    bb scripts/split.clj
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Modules updated successfully${NC}"
    else
        echo -e "${RED}⚠️  Warning: Split script failed${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Warning: Babashka (bb) not found - skipping module split${NC}"
    echo -e "${NC}   Install from: https://babashka.org/${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Done!${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "${NC}  - Review changes: git diff src/${NC}"
echo -e "${NC}  - Build variants: bb scripts/build.clj full${NC}"
echo -e "${NC}  - Commit changes: git add . && git commit -m 'feat: describe changes'${NC}"
echo -e "${NC}  - Push to remote: git push${NC}"
