# Logseq Template Graph

A comprehensive starter template for **Logseq Database** that brings **Tana-style supertag** functionality using **Schema.org vocabulary**. Import this template to instantly get structured classes and properties for organizing your knowledge.

## 🎯 What This Project Does

This template provides **47 pre-built classes and 129 properties** that you can import into your Logseq DB graph to:

- ✅ Tag notes with structured types (`#Person`, `#Organization`, `#Event`, etc.)
- ✅ Get automatic fields/properties on tagged pages
- ✅ Use industry-standard Schema.org naming conventions
- ✅ Build a structured knowledge graph like Tana, but in open-source Logseq

## 🚀 Quick Start (For Users)

### Prerequisites

- Logseq DB version installed (alpha release, 2025+)

### Import the Template

1. **Download** the template file: [`logseq_db_Templates.edn`](logseq_db_Templates.edn)

2. **Import into Logseq:**
   - Open Logseq
   - Go to: Settings (⚙️) → Import → **EDN to DB Graph**
   - Select the downloaded `logseq_db_Templates.edn` file
   - Wait for import to complete

3. **Start using!** Tag any page with:
   - `#Person` → Get properties: email, jobTitle, birthDate, spouse, etc.
   - `#Organization` → Get properties: legalName, employee, member, address, etc.
   - `#Event` → Get properties: eventStatus, attendee, organizer, eventSchedule, etc.
   - `#Place` → Get properties: address, keywords, events, etc.

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

Want to contribute or build your own templates?

### Setup Development Environment

1. **Install Logseq CLI:**
   ```bash
   npm install -g @logseq/cli
   ```

2. **Clone this repository:**
   ```bash
   git clone https://github.com/C0ntr0lledCha0s/logseq-template-graph.git
   cd logseq-template-graph
   ```

3. **Set your graph path:**
   ```bash
   # Windows (PowerShell)
   $env:LOGSEQ_GRAPH_PATH = "C:\Users\YourName\Logseq\template-dev"

   # Mac/Linux (Bash)
   export LOGSEQ_GRAPH_PATH="$HOME/Logseq/template-dev"
   ```

4. **Export your changes:**
   ```bash
   # Windows
   .\scripts\export.ps1

   # Mac/Linux
   ./scripts/export.sh
   ```

👉 **Read [QUICK_START.md](QUICK_START.md) for detailed setup**
👉 **Read [DEV_WORKFLOW.md](DEV_WORKFLOW.md) for full CI/CD pipeline**

### Development Workflow

```bash
# 1. Make changes in Logseq
# ... edit classes and properties ...

# 2. Export to version-controlled files
./scripts/export.sh

# 3. Review changes
git diff logseq_db_Templates.edn

# 4. Commit
git add logseq_db_Templates*.edn
git commit -m "feat: add Recipe class"
git push
```

**No more timestamp filenames!** 🎉 The scripts export to clean, consistent filenames.

## 📚 Documentation

- **[QUICK_START.md](QUICK_START.md)** - Get started in 5 minutes
- **[DEV_WORKFLOW.md](DEV_WORKFLOW.md)** - Complete CI/CD pipeline guide
- **[RESEARCH_REPORT.md](RESEARCH_REPORT.md)** - Deep dive into Logseq DB, Tana, and Schema.org
- **[CLAUDE.md](CLAUDE.md)** - Technical architecture for Claude Code

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

Contributions welcome! To add new classes or properties:

1. Fork this repository
2. Set up the development environment (see above)
3. Make your changes in your Logseq graph
4. Export using `./scripts/export.sh`
5. Submit a pull request

**What to contribute:**
- New Schema.org classes (Book, Article, Recipe, Product, etc.)
- Additional properties for existing classes
- Domain-specific templates (Research, CRM, Project Management)
- Documentation improvements

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

- [x] Core classes (Person, Organization, Event, Place)
- [x] Automated export workflow
- [x] Developer documentation
- [ ] Add CreativeWork classes (Book, Article, Recipe)
- [ ] Add Product and Review classes
- [ ] Multiple template variants (CRM, Research, Content)
- [ ] Query templates
- [ ] Video tutorials
- [ ] Template marketplace

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 💬 Community

- **Issues**: [GitHub Issues](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues)
- **Discussions**: [Logseq Forums](https://discuss.logseq.com)
- **Updates**: Watch this repository for releases

## 🙏 Acknowledgments

- **Logseq Team** - For building an amazing open-source knowledge tool
- **Schema.org** - For providing standardized vocabulary
- **Tana** - For pioneering the supertag paradigm
- **Community** - For feedback and contributions

---

**Made with ❤️ for the Logseq community**

*Give Logseq Database the structure it deserves! ⚡*
