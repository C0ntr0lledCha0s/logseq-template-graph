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

# If arguments provided, validate those files; otherwise use defaults
if [ $# -gt 0 ]; then
    FILES=("$@")
else
    FILES=(logseq_db_Templates.edn logseq_db_Templates_full.edn)
fi

# Check if files exist
for file in "${FILES[@]}"; do
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

    # Determine if this is a modular source file or complete template
    IS_MODULAR=false
    if [[ "$file" == source/* ]]; then
        IS_MODULAR=true
    fi

    if [ "$IS_MODULAR" = false ]; then
        # Check starts with {:properties (only for complete templates)
        if ! head -1 "$file" | grep -q "^{:properties"; then
            echo -e "${RED}  ❌ File doesn't start with {:properties${NC}"
            ERRORS=$((ERRORS + 1))
        else
            echo -e "${GREEN}  ✅ Valid EDN structure${NC}"
        fi

        # Check ends with export type marker (only for complete templates)
        if ! tail -1 "$file" | grep -q "logseq.db.sqlite.export/export-type"; then
            echo -e "${RED}  ❌ File doesn't end with export-type marker${NC}"
            ERRORS=$((ERRORS + 1))
        else
            echo -e "${GREEN}  ✅ Valid export marker${NC}"
        fi
    else
        # For modular files, just check valid EDN structure
        if head -1 "$file" | grep -q "^{"; then
            echo -e "${GREEN}  ✅ Valid modular EDN structure${NC}"
        else
            echo -e "${RED}  ❌ Invalid EDN structure${NC}"
            ERRORS=$((ERRORS + 1))
        fi
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
    if [ "$IS_MODULAR" = false ]; then
        # For complete templates, count unique definitions by looking for key patterns
        PROP_COUNT=$(sed -n '/:properties/,/:classes/p' "$file" | grep -E '^\s+:[a-z][a-zA-Z0-9]*-[a-zA-Z0-9_]+' | wc -l)
        CLASS_COUNT=$(sed -n '/:classes/,/:logseq.db.sqlite.export/p' "$file" | grep -E '^\s+:[A-Z][a-zA-Z0-9]*-[a-zA-Z0-9_]+' | wc -l)
    else
        # For modular files, count all occurrences (simpler approach)
        PROP_COUNT=$(grep -c "user.property/" "$file" || echo "0")
        CLASS_COUNT=$(grep -c "user.class/" "$file" || echo "0")
    fi

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

# Run UUID reference validation on source files
echo -e "${CYAN}🔍 Validating UUID references in source files...${NC}"
echo ""

if [ -d "source" ]; then
    if command -v bb >/dev/null 2>&1; then
        bb scripts/validate-refs.clj
        if [ $? -ne 0 ]; then
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo -e "${YELLOW}  ⚠️  Babashka not installed - skipping UUID reference validation${NC}"
        echo -e "${YELLOW}     Install Babashka from https://babashka.org/ to enable this check${NC}"
    fi
else
    echo -e "${YELLOW}  ⚠️  source/ directory not found - skipping UUID validation${NC}"
fi

echo ""

# Final result
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s)${NC}"
    exit 1
fi
