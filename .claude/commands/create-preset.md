# Create Preset Command

Guide the user through creating a custom template preset interactively.

## What This Does

This command creates a new preset configuration file that defines which modules to include in a custom template variant. Presets allow users to build optimized templates for specific use cases.

## Process

### 1. Introduction
Explain what presets are and show examples:
```
🎨 Custom Preset Creator
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Presets define custom template variants by selecting which
modules to include. This allows you to create optimized
templates for specific use cases.

📋 Existing Presets:
- full: Everything (632 classes, 1,033 properties)
- crm: Person + Organization (8 classes, 240 properties)
- research: Books + Articles (22 classes, 247 properties)
- content: Creative works (18 classes, 228 properties)
- events: Event management (24 classes, 252 properties)

Let's create your custom preset!
```

### 2. Gather Basic Information

**Preset Name**
```
❓ What should we call this preset?
   (lowercase, no spaces, e.g., "my-workflow", "sales-pipeline")

   Preset name: _______
```

Validate:
- Lowercase only
- No spaces (use hyphens)
- Alphanumeric + hyphens
- Not a reserved name (full, crm, research, content, events)

**Description**
```
❓ Describe what this preset is for:
   (e.g., "Sales pipeline management with contacts and deals")

   Description: _______
```

**Use Case**
```
❓ Who will use this template?
   Examples:
   - Students tracking courses and assignments
   - Freelancers managing clients and projects
   - Researchers organizing papers and notes
   - Event planners coordinating meetings

   Use case: _______
```

### 3. Show Available Modules

Display all available modules with details:
```
📦 Available Modules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Essential (always recommended):
  [ ] base       - Thing, Agent (2 classes)
  [ ] common     - Shared properties (189 properties)

People & Organizations:
  [ ] person     - Person, Patient (2 classes, 36 properties)
  [ ] organization - Org, NGO, etc. (4 classes, 15 properties)

Content & Media:
  [ ] creative-work - Books, Articles, Videos (14 classes, 7 properties)
  [ ] event      - Events, Meetings (17 classes, 6 properties)

Location & Products:
  [ ] place      - Places, Locations (2 classes, 9 properties)
  [ ] product    - Products (1 class, 2 properties)

Other:
  [ ] intangible - Ratings, Values (9 classes, 9 properties)
  [ ] action     - Actions (1 class, 1 property)
  [ ] misc       - Everything else (82 classes, 59 properties)
```

### 4. Interactive Module Selection

**Guided Questions**
```
Let's select modules for your preset.

✅ Essential modules (recommended):
   → Adding: base, common

❓ Will you track people (contacts, users, team members)?
   [Y/n]: _____

   → Adding: person

❓ Will you track organizations (companies, teams, groups)?
   [Y/n]: _____

   → Adding: organization

❓ Will you track creative content (articles, videos, documents)?
   [y/N]: _____

❓ Will you track events (meetings, conferences, deadlines)?
   [y/N]: _____

❓ Will you track physical locations?
   [y/N]: _____

❓ Will you track products or inventory?
   [y/N]: _____

❓ Include everything else (misc module with 82+ classes)?
   [y/N]: _____

   Note: Only include if you need specialized classes like
   MedicalCondition, Invoice, Course, etc.
```

**Manual Selection Mode**
```
Or enter module names manually (space-separated):
Example: base common person organization event

Modules: _______
```

### 5. Show Selection Summary

```
📋 Your Preset Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Name: sales-pipeline
Description: Sales pipeline management with contacts and deals
Use Case: Freelancers managing clients and projects

Included Modules (5):
  ✓ base (2 classes)
  ✓ common (189 properties)
  ✓ person (2 classes, 36 properties)
  ✓ organization (4 classes, 15 properties)
  ✓ event (17 classes, 6 properties)

Estimated Size:
  Classes: ~25
  Properties: ~250
  File size: ~305 KB

❓ Does this look correct? [Y/n]: _____
```

### 6. Create Preset File

Generate the EDN preset configuration:

```clojure
{:name "Sales Pipeline"
 :description "Sales pipeline management with contacts and deals"
 :use-case "Freelancers managing clients and projects"
 :include ["base" "common" "person" "organization" "event"]
 :metadata
 {:created "2025-11-08"
  :author "User Name"
  :version "1.0"}}
```

Save to `source/presets/sales-pipeline.edn`

### 7. Build and Test

```
✅ Preset created: source/presets/sales-pipeline.edn

Next steps:

1. Build your custom template:
   npm run build:custom sales-pipeline

   Or:
   bb scripts/build.clj sales-pipeline

2. Output will be:
   build/logseq_db_Templates_sales-pipeline.edn

3. Test in Logseq:
   Settings → Import → EDN to DB Graph
   Select: build/logseq_db_Templates_sales-pipeline.edn

4. Customize further:
   Edit: source/presets/sales-pipeline.edn
   Then rebuild

❓ Would you like me to build it now? [Y/n]: _____
```

### 8. Optional: Build Immediately

If user confirms:
```bash
bb scripts/build.clj sales-pipeline
```

Show output:
```
🔨 Building template variant: sales-pipeline
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Reading preset: source/presets/sales-pipeline.edn
Loading modules: base, common, person, organization, event

✓ Loaded 25 classes
✓ Loaded 252 properties
✓ Validated structure
✓ Written to build/logseq_db_Templates_sales-pipeline.edn

📊 Template Statistics:
   Size: 305 KB
   Lines: 5,847
   Classes: 25
   Properties: 252

✅ Template built successfully!

📁 Import this file in Logseq:
   build/logseq_db_Templates_sales-pipeline.edn
```

### 9. Document the Preset

Offer to create documentation:
```
❓ Would you like me to document this preset? [Y/n]: _____
```

If yes, create `source/presets/README.md` entry or standalone doc:
```markdown
## sales-pipeline

**Purpose:** Sales pipeline management with contacts and deals

**Use Case:** Freelancers managing clients and projects

**Includes:**
- Person tracking (contacts, leads)
- Organization management (companies, clients)
- Event scheduling (meetings, follow-ups)
- Base ontology (Thing, Agent)
- Common properties (shared across all types)

**What you can track:**
- 👤 Contacts and leads
- 🏢 Client companies
- 📅 Sales meetings and follow-ups
- 💼 Business relationships
- 📞 Contact information

**What's NOT included:**
- Creative content (articles, videos)
- Products/inventory
- Physical locations
- Specialized classes (medical, financial, etc.)

**Size:** ~305 KB, 25 classes, 252 properties

**Build:**
```bash
npm run build:custom sales-pipeline
# or
bb scripts/build.clj sales-pipeline
```

**Import:**
```
Settings → Import → EDN to DB Graph
Select: build/logseq_db_Templates_sales-pipeline.edn
```
```

### 10. Add to npm Scripts (Optional)

```
❓ Would you like to add an npm script for easy building? [Y/n]: _____
```

If yes, show instructions:
```
I can add this to package.json for you.

This will let you run:
  npm run build:sales-pipeline

Instead of:
  bb scripts/build.clj sales-pipeline

❓ Proceed? [Y/n]: _____
```

If confirmed, update package.json:
```json
{
  "scripts": {
    "build:sales-pipeline": "bb scripts/build.clj sales-pipeline"
  }
}
```

## Validation Rules

### Preset Name
- Must be lowercase
- Only letters, numbers, hyphens
- No spaces
- Not empty
- Not a reserved name (full, crm, research, content, events)
- Pattern: `^[a-z][a-z0-9-]*$`

### Module Names
- Must exist in source/ directory
- Common valid modules: base, common, person, organization, event, creative-work, place, product, intangible, action, misc

### Required Modules
Always suggest including:
- `base` - Foundation classes
- `common` - Shared properties

## Examples

### Example 1: Student Template
```
Name: student-life
Description: Student course and assignment tracking
Use case: Students tracking courses, assignments, and study materials

Modules:
- base (foundation)
- common (shared properties)
- person (professors, classmates)
- organization (university, clubs)
- creative-work (books, papers)
- event (classes, exams)
- intangible (ratings for courses)
```

### Example 2: Freelancer Template
```
Name: freelance-work
Description: Freelancer client and project management
Use case: Freelancers managing clients, projects, and invoices

Modules:
- base
- common
- person (clients, contacts)
- organization (client companies)
- creative-work (deliverables)
- event (meetings, deadlines)
- misc (for Invoice class)
```

### Example 3: Content Creator Template
```
Name: content-creator
Description: Content creation and publishing workflow
Use case: Bloggers, YouTubers, content creators

Modules:
- base
- common
- person (collaborators, audience)
- creative-work (articles, videos, images)
- event (publishing schedule)
- organization (brands, sponsors)
```

## Error Handling

### Invalid Preset Name
```
❌ Error: Preset name "My Template" is invalid

Preset names must:
- Be lowercase
- Use hyphens instead of spaces
- Only contain letters, numbers, and hyphens

Suggestion: "my-template"

Try again: _____
```

### Reserved Name
```
❌ Error: "full" is a reserved preset name

Reserved names: full, crm, research, content, events

Please choose a different name: _____
```

### Invalid Module
```
❌ Error: Module "medical" does not exist

Available modules:
  base, common, person, organization, event,
  creative-work, place, product, intangible,
  action, misc

Try again: _____
```

### No Modules Selected
```
❌ Error: No modules selected

You must select at least:
- base (foundation classes)
- common (shared properties)

Would you like to:
  1. Start over with guided questions
  2. Enter modules manually
  3. Cancel

Choice: _____
```

## Success Criteria

- Interactive and user-friendly
- Clear explanations at each step
- Validation of all inputs
- Helpful error messages
- Summary before creating file
- Option to build immediately
- Documentation generated
- Easy to iterate and refine

## Tools to Use

- **Read**: Check existing presets
- **Write**: Create new preset file
- **Bash**: Run build commands, check if babashka is installed
- **Glob**: Find existing modules
- **Edit**: Update package.json if adding npm script

## Notes

- Make this friendly and interactive
- Use emojis for visual clarity (✓, ❌, ❓, 📋, etc.)
- Provide examples throughout
- Show estimated sizes
- Allow easy iteration
- Document the creation
- Build and test immediately

---

**This command should make creating custom presets fun and easy, even for non-technical users!**
