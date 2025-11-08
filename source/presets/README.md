# Template Presets

This directory contains preset configurations for building custom template variants. Each preset defines which modules to include, allowing you to create optimized templates for specific use cases.

## Available Presets

### full
**Purpose:** Complete template with all Schema.org classes and properties

**What's included:**
- All 632 classes
- All 1,033 properties
- Complete Schema.org vocabulary

**Size:** ~15,422 lines, ~2.1 MB

**Build:**
```bash
npm run build:full
# or
bb scripts/build.clj full
```

---

### crm
**Purpose:** Customer relationship management - Person, Organization, and Contact

**What's included:**
- Person tracking (contacts, leads, customers)
- Organization management (companies, clients)
- Base ontology (Thing, Agent)
- Common properties (shared across all types)

**Use case:** Sales teams, freelancers, consultants

**Build:**
```bash
npm run build:crm
# or
bb scripts/build.clj crm
```

---

### research
**Purpose:** Academic and research notes - Books, Articles, Authors, Publications

**What's included:**
- Person tracking (authors, researchers)
- Organization tracking (institutions, publishers)
- Creative works (books, articles, papers)
- Base ontology
- Common properties

**Use case:** Researchers, academics, graduate students, writers

**Build:**
```bash
npm run build:research
# or
bb scripts/build.clj research
```

---

### student-life
**Purpose:** Student course and assignment tracking

**What you can track:**
- 👤 Professors, classmates, study partners
- 📚 Textbooks, research papers, study materials
- 📅 Classes, exams, deadlines, study sessions
- 📍 Campus locations, libraries, study rooms
- ⭐ Course ratings and reviews

**What's included:**
- Person module (professors, classmates)
- Creative Work module (textbooks, papers)
- Event module (classes, exams, deadlines)
- Place module (campus, study rooms)
- Intangible module (ratings, reviews)
- Base ontology
- Common properties

**Use case:** Students tracking courses, assignments, professors, and study materials

**Size:** ~8,015 lines, 113 classes, 302 properties

**Build:**
```bash
npm run build:student-life
# or
bb scripts/build.clj student-life
```

**Import:**
```
Settings → Import → EDN to DB Graph
Select: build/logseq_db_Templates_student-life.edn
```

---

## Creating Custom Presets

### Option 1: Use the `/create-preset` command (Recommended)

Interactive preset creation wizard:
```
/create-preset
```

This will guide you through:
1. Naming your preset
2. Adding a description
3. Selecting modules interactively
4. Building and testing

### Option 2: Manual Creation

1. Create a new `.edn` file in this directory:

```clojure
{:name "My Custom Template"
 :description "Brief description of what this preset includes"
 :use-case "Who will use this and for what purpose"
 :include ["base" "common" "person" "organization"]
 :metadata
 {:created "2025-11-08"
  :version "1.0"}}
```

2. Build your preset:

```bash
bb scripts/build.clj my-custom-preset
```

3. Add to `package.json` for easy building:

```json
"build:my-custom-preset": "bb scripts/build.clj my-custom-preset"
```

## Available Modules

### Essential (always recommended)
- **base** - Thing, Agent (foundation classes)
- **common** - Shared properties across all types

### People & Organizations
- **person** - Person, Patient (contacts, team members)
- **organization** - Organizations, NGOs, companies

### Content & Media
- **creative-work** - Books, Articles, Videos, Podcasts
- **event** - Events, Meetings, Conferences

### Location & Products
- **place** - Places, Locations, Addresses
- **product** - Products, Offers

### Specialized
- **health** - Medical entities (MedicalCondition, etc.)
- **intangible** - Ratings, Values, Quantities
- **action** - Actions, Tasks
- **misc** - Everything else (82+ specialized classes)

## Preset File Format

```clojure
{:name "Display Name"              ; Human-readable name
 :description "Short description"   ; What this preset includes
 :use-case "Target audience"        ; Who uses this and why
 :include ["module1" "module2"]     ; List of modules to include
 :metadata
 {:created "YYYY-MM-DD"             ; Creation date
  :version "1.0"}}                  ; Version number
```

## Module Selection Guide

### For Students
```clojure
:include ["base" "common" "person" "creative-work" "event" "place" "intangible"]
```
Track courses, professors, textbooks, exams, campus locations, ratings

### For Freelancers
```clojure
:include ["base" "common" "person" "organization" "creative-work" "event"]
```
Track clients, companies, projects, deliverables, meetings

### For Content Creators
```clojure
:include ["base" "common" "person" "organization" "creative-work" "event"]
```
Track collaborators, brands, content pieces, publishing schedule

### For Event Planners
```clojure
:include ["base" "common" "person" "organization" "event" "place"]
```
Track attendees, vendors, events, venues

### For Researchers
```clojure
:include ["base" "common" "person" "organization" "creative-work"]
```
Track authors, institutions, papers, publications

## Best Practices

1. **Always include base + common**
   - `base` provides foundation classes (Thing, Agent)
   - `common` provides shared properties

2. **Start small, add modules as needed**
   - Begin with minimal modules
   - Add more based on actual usage
   - Easier to expand than to trim down

3. **Test before committing**
   - Build and test in a fresh Logseq graph
   - Verify all expected classes and properties appear
   - Check for any conflicts or issues

4. **Document your presets**
   - Add clear descriptions
   - Specify use cases
   - List what's included and what's not

5. **Version your presets**
   - Use semantic versioning in metadata
   - Track changes over time
   - Update version on modifications

## Troubleshooting

### Build fails with "module not found"
Check that module names in `:include` match directory names in `source/`.

### Template too large
Remove modules you don't need, especially `misc` which has 82+ classes.

### Missing classes or properties
Ensure you've included all required modules. Check module dependencies.

### Want to customize further
Edit individual module files in `source/[module-name]/` before building.

## Resources

- [Modular Workflow Quickstart](../../docs/modular/quickstart.md)
- [Complete Modularization Strategy](../../docs/modular/strategy.md)
- [Technical Reference](../../docs/architecture/technical-reference.md)
- [CLAUDE.md](../../CLAUDE.md) - Main project documentation

---

**Last Updated:** November 2025
