# Logseq Template Graph

A comprehensive starter template for **Logseq Database** that brings **Tana-style supertag** functionality using **Schema.org vocabulary**. Import this template to instantly get structured classes and properties for organizing your knowledge.

**Quick Links:** [Quick Start](QUICK_START.md) | [Developer Guide](docs/developer-guide/ci-cd-pipeline.md) | [📚 Documentation](docs/README.md) | [Contributing](#-contributing)

---

## Table of Contents

- [What This Project Does](#-what-this-project-does)
- [Quick Start](#-quick-start)
- [What's Included](#-whats-included)
- [For Template Developers](#-for-template-developers)
- [Documentation](#-documentation)
- [Why Use This Template](#-why-use-this-template)
- [Contributing](#-contributing)
- [Roadmap](#-roadmap)
- [License](#-license)

---

## 🎯 What This Project Does

This template provides **47 pre-built classes and 129 properties** that you can import into your Logseq DB graph to:

- ✅ Tag notes with structured types (`#Person`, `#Organization`, `#Event`, etc.)
- ✅ Get automatic fields/properties on tagged pages
- ✅ Use industry-standard Schema.org naming conventions
- ✅ Build a structured knowledge graph like Tana, but in open-source Logseq

## 🚀 Quick Start

### For Users: Import Templates

**Prerequisites:**
- Logseq Database version installed ([installation guide](QUICK_START.md#step-0-install-logseq-database-version))

**3-Step Setup:**

1. **Download** the template: [logseq_db_Templates.edn](logseq_db_Templates.edn)

2. **Import** into Logseq:
   - Open Logseq → Settings (⚙️) → Import → **EDN to DB Graph**
   - Select `logseq_db_Templates.edn`

3. **Start using** structured types:
   - `#Person` → email, jobTitle, birthDate, etc.
   - `#Organization` → legalName, employee, member, etc.
   - `#Event` → eventStatus, attendee, organizer, etc.

**Detailed guide:** [QUICK_START.md](QUICK_START.md)

[Back to top](#logseq-template-graph)

## 📦 What's Included

### Classes (Types)

- **Thing** - Base class for everything
- **Person** - People with contact info, relationships, occupations
- **Organization** - Companies, teams, institutions
- **Event** - Meetings, conferences, occasions
  - EventSeries - Recurring events
  - BusinessMeeting - Work meetings
- **Place** - Locations and addresses
- **Occupation** - Job roles and skills
- **Schedule** - Recurring time patterns
- **Audience** - Target groups
- **Resource** - Generic resources

### Property Types

Properties support multiple types:
- **Text** - Free-form content
- **Node** - Links to other pages (relationships)
- **Date** - Calendar dates
- **URL** - Web links
- **Number** - Numeric values
- **Choices** - Pre-defined options (like event status)

### Example: Person Class

When you tag a page with `#Person`, you automatically get these properties:

- jobTitle
- email
- givenName (first name)
- familyName (last name)
- birthDate
- spouse (links to another Person)
- children (multiple Person links)
- worksFor (links to Organization)
- alumniOf (educational institution)
- knows (other people)
- skills

...and 15+ more Schema.org properties!

## 🛠️ For Template Developers

Want to contribute or customize templates?

### Quick Setup

```bash
# 1. Install Logseq CLI
npm install -g @logseq/cli

# 2. Clone this repository
git clone https://github.com/C0ntr0lledCha0s/logseq-template-graph.git
cd logseq-template-graph

# 3. Set your graph path
export LOGSEQ_GRAPH_PATH="$HOME/Logseq/template-dev"

# 4. Export your changes
./scripts/export.sh
```

### Development Workflow

```bash
# 1. Make changes in Logseq → 2. Export → 3. Review → 4. Commit
./scripts/export.sh && git diff && git add . && git commit -m "feat: add Recipe class"
```

**No more timestamp filenames!** 🎉 Scripts export to clean, version-controlled files.

**Complete guides:**
- [QUICK_START.md](QUICK_START.md) - 5-minute developer setup
- [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) - Full automation workflow
- [Modular Development](docs/modular/quickstart.md) - For large templates

[Back to top](#logseq-template-graph)

## 📚 Documentation

**📁 Organized Documentation:** [Documentation Portal](docs/README.md) - All guides organized by category in the `docs/` folder.

**Quick Index:** [DOCS_INDEX.md](DOCS_INDEX.md) - Complete documentation map by task and audience.

### Quick Access

| Guide | For | What's Inside |
|-------|-----|---------------|
| [QUICK_START.md](QUICK_START.md) | Users & Developers | Installation, import instructions, dev setup |
| [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) | Developers | Workflows, automation, modular development |
| [Technical Reference](docs/architecture/technical-reference.md) | Developers & AI | EDN format, classes, best practices |
| [Comprehensive Analysis](docs/research/comprehensive-analysis.md) | Everyone | Deep dive: Logseq DB, Tana, Schema.org |
| [Modular Quickstart](docs/modular/quickstart.md) | Developers | For large templates (15K+ lines) |

**Recommended Reading Order:**
1. Users: [README](README.md) → [QUICK_START](QUICK_START.md)
2. Developers: [QUICK_START](QUICK_START.md) → [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) → [Technical Reference](docs/architecture/technical-reference.md)

[Back to top](#logseq-template-graph)

## 🌟 Why Use This Template?

### vs. Starting from Scratch

❌ **Without template:**
- Blank slate, no structure
- Inconsistent property names
- Reinvent the wheel for common types
- Hours of setup work

✅ **With this template:**
- Instant structure for common types
- Schema.org standard naming
- Ready to use in seconds
- Battle-tested vocabulary

### vs. Tana

This template brings **Tana's supertag experience** to Logseq:

| Feature | Tana | This Template |
|---------|------|---------------|
| Typed objects | ✅ Supertags | ✅ Classes |
| Auto fields | ✅ | ✅ Properties |
| Inheritance | ✅ | ✅ Class parents |
| Open source | ❌ Proprietary | ✅ MIT License |
| Local-first | ❌ Cloud | ✅ Local SQLite |
| Cost | 💰 Paid | 🆓 Free |

## 🤝 Contributing

Contributions welcome! We'd love your help expanding this template library.

### How to Contribute

1. **Fork** this repository
2. **Set up** the development environment ([guide](QUICK_START.md#for-developers-set-up-development-environment))
3. **Make changes** in your Logseq graph
4. **Export** using `./scripts/export.sh`
5. **Submit** a pull request

### What to Contribute

- New Schema.org classes (Book, Article, Recipe, Product, etc.)
- Additional properties for existing classes
- Domain-specific templates (Research, CRM, Project Management)
- Documentation improvements
- Bug fixes and validation improvements

### Contribution Guidelines

- Follow Schema.org naming conventions
- Include icons and descriptions for new classes/properties
- Test imports before submitting
- Update documentation as needed

**See:** [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) for detailed development process

[Back to top](#logseq-template-graph)

## 📖 Learn More

### About the Technologies

- **Logseq Database** - SQLite-based knowledge management (2025 alpha)
  - [Official Docs](https://docs.logseq.com)
  - [DB Version Guide](https://github.com/logseq/docs/blob/master/db-version.md)

- **Schema.org** - Structured vocabulary for the web
  - [Schema.org Homepage](https://schema.org)
  - [Person Type](https://schema.org/Person)
  - [Organization Type](https://schema.org/Organization)
  - [Event Type](https://schema.org/Event)

- **Tana** - Inspiration for supertag paradigm
  - [Tana Supertags](https://tana.inc/docs/supertags)

## 🗺️ Roadmap

### Phase 1: Core Foundation ✅
- [x] Core classes (Person, Organization, Event, Place)
- [x] Automated export workflow
- [x] Comprehensive documentation
- [x] CI/CD pipeline

### Phase 2: Expansion 🚧
- [ ] Add CreativeWork classes (Book, Article, Recipe)
- [ ] Add Product and Review classes
- [ ] Community sharing and feedback

### Phase 3: Ecosystem 🔮
- [ ] Multiple template variants (CRM, Research, Content)
- [ ] Query templates and examples
- [ ] Video tutorials
- [ ] Template marketplace

[Back to top](#logseq-template-graph)

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 💬 Community & Support

### Get Help
- [GitHub Issues](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues) - Bug reports and feature requests
- [Logseq Forums](https://discuss.logseq.com) - General discussion
- [Documentation](.) - Comprehensive guides

### Stay Updated
- Watch this repository for new releases
- Check the [Roadmap](#-roadmap) for upcoming features
- Join discussions in issues and pull requests

## 🙏 Acknowledgments

- **Logseq Team** - For building an amazing open-source knowledge tool
- **Schema.org** - For providing standardized vocabulary
- **Tana** - For pioneering the supertag paradigm
- **Community** - For feedback and contributions

[Back to top](#logseq-template-graph)

---

**Made with ❤️ for the Logseq community**

*Give Logseq Database the structure it deserves! ⚡*

**Quick Links:** [Quick Start](QUICK_START.md) | [Developer Guide](docs/developer-guide/ci-cd-pipeline.md) | [📚 Documentation](docs/README.md) | [Contributing](#-contributing)
