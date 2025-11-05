#!/bin/bash

# Initialize Modular Structure for Logseq Template Graph
# This script sets up everything needed for modular development

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  LOGSEQ TEMPLATE MODULARIZATION SETUP${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if Babashka is installed
echo -e "${YELLOW}🔍 Checking for Babashka...${NC}"
if ! command -v bb &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Babashka...${NC}"

    # Detect OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install borkdude/brew/babashka
        else
            echo -e "${RED}❌ Homebrew not found. Please install: https://brew.sh${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)
    else
        # Windows (via Git Bash/WSL)
        echo -e "${YELLOW}For Windows, please install Babashka manually:${NC}"
        echo "  https://github.com/babashka/babashka#installation"
        exit 1
    fi

    if command -v bb &> /dev/null; then
        echo -e "${GREEN}✅ Babashka installed successfully${NC}"
    else
        echo -e "${RED}❌ Failed to install Babashka${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Babashka already installed ($(bb --version))${NC}"
fi

# Create directory structure
echo -e "\n${YELLOW}📁 Creating directory structure...${NC}"
mkdir -p source/{base,person,organization,event,place,creative-work,product,action,intangible,misc,presets,common}
mkdir -p build
mkdir -p archive/pre-modular
echo -e "${GREEN}✅ Directories created${NC}"

# Make scripts executable
echo -e "\n${YELLOW}🔧 Making scripts executable...${NC}"
chmod +x scripts/split.clj
chmod +x scripts/build.clj
chmod +x scripts/export.sh 2>/dev/null || true
chmod +x scripts/validate.sh 2>/dev/null || true
echo -e "${GREEN}✅ Scripts are executable${NC}"

# Create preset files
echo -e "\n${YELLOW}📋 Creating preset configurations...${NC}"

cat > source/presets/full.edn << 'EOF'
{:name "Full Template"
 :description "Complete Schema.org-based template with all classes and properties"
 :include nil}  ; nil means include everything
EOF

cat > source/presets/crm.edn << 'EOF'
{:name "CRM Template"
 :description "Customer relationship management - Person, Organization, and Contact"
 :include ["person" "organization" "base" "common"]}
EOF

cat > source/presets/research.edn << 'EOF'
{:name "Research Template"
 :description "Academic and research notes - Books, Articles, Authors, Publications"
 :include ["person" "organization" "creative-work" "base" "common"]}
EOF

cat > source/presets/content.edn << 'EOF'
{:name "Content Creation Template"
 :description "Content creators - Videos, Articles, Images, Media"
 :include ["person" "creative-work" "base" "common"]}
EOF

cat > source/presets/events.edn << 'EOF'
{:name "Events Template"
 :description "Event management - Meetings, Conferences, Schedules"
 :include ["person" "organization" "event" "place" "base" "common"]}
EOF

echo -e "${GREEN}✅ Preset configurations created${NC}"

# Archive original file if it exists
if [ -f "logseq_db_Templates.edn" ]; then
    echo -e "\n${YELLOW}💾 Archiving original template...${NC}"
    cp logseq_db_Templates.edn archive/pre-modular/
    git tag v1.0-monolith 2>/dev/null || echo "  (git tag skipped)"
    echo -e "${GREEN}✅ Original backed up to archive/pre-modular/${NC}"
else
    echo -e "\n${YELLOW}⚠️  No logseq_db_Templates.edn found to archive${NC}"
fi

# Update .gitignore
echo -e "\n${YELLOW}📝 Updating .gitignore...${NC}"
if ! grep -q "^build/" .gitignore 2>/dev/null; then
    cat >> .gitignore << 'EOF'

# Modular build artifacts
build/
*.swp
.bb-cache/
EOF
    echo -e "${GREEN}✅ .gitignore updated${NC}"
else
    echo -e "${GREEN}✅ .gitignore already configured${NC}"
fi

# Run initial split if template exists
if [ -f "logseq_db_Templates.edn" ]; then
    echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  SPLITTING TEMPLATE INTO MODULES${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    bb scripts/split.clj
else
    echo -e "\n${YELLOW}⚠️  No template file to split. You'll need to:${NC}"
    echo "  1. Export your Logseq graph to logseq_db_Templates.edn"
    echo "  2. Run: bb scripts/split.clj"
fi

# Summary
echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  SETUP COMPLETE!${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${GREEN}✅ Modular structure initialized!${NC}"

echo -e "\n${YELLOW}📁 Directory structure:${NC}"
echo "  source/          - Modular source files"
echo "  build/           - Compiled templates"
echo "  archive/         - Backups"
echo "  scripts/         - Build scripts"

echo -e "\n${YELLOW}💡 Next steps:${NC}"
echo "  1. Review modules:    tree source/ (or ls -R source/)"
echo "  2. Build full:        bb scripts/build.clj full"
echo "  3. Build CRM:         bb scripts/build.clj crm"
echo "  4. Build Research:    bb scripts/build.clj research"
echo "  5. Validate:          ./scripts/validate.sh build/logseq_db_Templates_full.edn"
echo "  6. Test import:       Import build/*.edn into Logseq"

echo -e "\n${YELLOW}📚 Documentation:${NC}"
echo "  - MODULARIZATION_PLAN.md  - Complete strategy"
echo "  - DEV_WORKFLOW.md          - Development workflow"
echo "  - source/*/README.md       - Per-module docs"

echo -e "\n${GREEN}🎉 Ready for modular development!${NC}"
