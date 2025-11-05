#!/bin/bash

# Logseq Template Validation Script
# Validates EDN files before committing

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🔍 Validating Logseq Template EDN files...${NC}"
echo ""

ERRORS=0

# Check if files exist
for file in logseq_db_Templates.edn logseq_db_Templates_full.edn; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}❌ $file not found!${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    echo -e "${YELLOW}Checking $file...${NC}"

    # Check file is not empty
    if [ ! -s "$file" ]; then
        echo -e "${RED}  ❌ File is empty!${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi

    # Check starts with {:properties
    if ! head -1 "$file" | grep -q "^{:properties"; then
        echo -e "${RED}  ❌ File doesn't start with {:properties${NC}"
        ERRORS=$((ERRORS + 1))
    else
        echo -e "${GREEN}  ✅ Valid EDN structure${NC}"
    fi

    # Check ends with export type marker
    if ! tail -1 "$file" | grep -q "logseq.db.sqlite.export/export-type"; then
        echo -e "${RED}  ❌ File doesn't end with export-type marker${NC}"
        ERRORS=$((ERRORS + 1))
    else
        echo -e "${GREEN}  ✅ Valid export marker${NC}"
    fi

    # Check for timestamp in filename (common mistake)
    if echo "$file" | grep -q "_[0-9]\{10,\}"; then
        echo -e "${RED}  ❌ File contains timestamp in name!${NC}"
        echo -e "${YELLOW}     Use clean filenames: logseq_db_Templates.edn${NC}"
        ERRORS=$((ERRORS + 1))
    fi

    # Check file content for accidental timestamps in references
    if grep -q "logseq_db_Templates_[0-9]" "$file"; then
        echo -e "${YELLOW}  ⚠️  File contains timestamped references${NC}"
    fi

    # Count properties and classes
    PROP_COUNT=$(grep -c "user.property/" "$file" || echo "0")
    CLASS_COUNT=$(grep -c "user.class/" "$file" || echo "0")

    echo -e "${CYAN}  📊 Properties: ${PROP_COUNT}${NC}"
    echo -e "${CYAN}  📊 Classes: ${CLASS_COUNT}${NC}"

    # Warn if counts seem low
    if [ "$PROP_COUNT" -lt 10 ]; then
        echo -e "${YELLOW}  ⚠️  Low property count - is this correct?${NC}"
    fi

    if [ "$CLASS_COUNT" -lt 5 ]; then
        echo -e "${YELLOW}  ⚠️  Low class count - is this correct?${NC}"
    fi

    echo ""
done

# Final result
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s)${NC}"
    exit 1
fi
