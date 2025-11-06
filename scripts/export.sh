#!/bin/bash

# Logseq Template Graph Export Script
# This script exports your development graph to clean, version-controlled EDN files

set -e  # Exit on error

# Configuration
GRAPH_PATH="${LOGSEQ_GRAPH_PATH:-$HOME/logseq/graphs/Test Build}"
OUTPUT_DIR="${LOGSEQ_OUTPUT_DIR:-.}"
DATE=$(date +%Y-%m-%d)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}🚀 Exporting Logseq Template Graph...${NC}"
echo -e "${YELLOW}Graph: ${GRAPH_PATH}${NC}"
echo ""

# Check if Logseq CLI is installed
if ! command -v logseq &> /dev/null; then
    echo -e "${RED}❌ Error: Logseq CLI not found${NC}"
    echo -e "${YELLOW}Install with: npm install -g @logseq/cli${NC}"
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
else
    OUTPUT_DIR_ABS="$(cd "$OUTPUT_DIR" && pwd)"
fi

echo -e "${CYAN}Output directory: $OUTPUT_DIR_ABS${NC}"
echo ""

# Export template (clean, no timestamps)
echo -e "${YELLOW}📦 Exporting template...${NC}"
OUTPUT_FILE="$OUTPUT_DIR_ABS/logseq_db_Templates.edn"
echo -e "${CYAN}Target file: $OUTPUT_FILE${NC}"
logseq export-edn \
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
if command -v wc &> /dev/null; then
    LINES=$(wc -l < "logseq_db_Templates.edn")
    echo -e "${CYAN}📊 Statistics:${NC}"
    echo -e "   Lines: ${LINES}"
fi

if command -v grep &> /dev/null; then
    PROP_COUNT=$(grep -c "user.property/" "logseq_db_Templates.edn" || echo "0")
    CLASS_COUNT=$(grep -c "user.class/" "logseq_db_Templates.edn" || echo "0")
    echo -e "   Properties: ${PROP_COUNT}"
    echo -e "   Classes: ${CLASS_COUNT}"
fi

echo ""

# Show git changes
if command -v git &> /dev/null && [ -d .git ]; then
    echo -e "${CYAN}📊 Git changes:${NC}"
    git diff --stat logseq_db_Templates.edn 2>/dev/null || echo "   No changes detected"
    echo ""
fi

# Optional: Auto-commit prompt
echo -e "${YELLOW}Would you like to commit these changes? (y/n)${NC}"
read -p "> " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Enter commit message (or press Enter for default):${NC}"
    read -p "> " COMMIT_MSG

    if [ -z "$COMMIT_MSG" ]; then
        COMMIT_MSG="chore: auto-export templates on $DATE"
    fi

    git add logseq_db_Templates.edn
    git commit -m "$COMMIT_MSG"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Changes committed${NC}"
        echo -e "${YELLOW}Push to remote? (y/n)${NC}"
        read -p "> " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git push
            echo -e "${GREEN}✅ Changes pushed${NC}"
        fi
    else
        echo -e "${RED}❌ Failed to commit changes${NC}"
    fi
else
    echo -e "${YELLOW}💡 Tip: Review changes with: git diff logseq_db_Templates.edn${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Done!${NC}"
