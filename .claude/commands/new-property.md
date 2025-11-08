# Create New Schema.org Property

Interactive workflow to add a new property to the template with Schema.org integration.

This is an **enhanced version** of `/add-property` with better type mapping, validation, and automation.

## What This Does

1. **Research Schema.org** - Fetches property definition, expected types, usage
2. **Type Mapping** - Maps Schema.org types to Logseq types automatically
3. **Cardinality Detection** - Suggests `:one` or `:many` based on Schema.org
4. **Class Association** - Shows which classes should use this property
5. **Generate Definition** - Creates EDN with proper structure
6. **Update Module** - Adds to appropriate source module
7. **Build & Validate** - Tests all variants
8. **Generate Commit** - Creates conventional commit message

## Usage

```
/new-property [propertyName]
```

**Examples:**
```bash
/new-property jobTitle
/new-property cookTime
/new-property isbn
/new-property alumniOf
```

## Interactive Workflow

### Step 1: Research Schema.org

```
🔍 Researching Schema.org for "jobTitle"...

Found: https://schema.org/jobTitle

📋 Property Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Name: jobTitle
Description: The job title of the person (for example, Financial Manager)
Expected Type: Text or DefinedTerm
Domain: Person, Organization
Range: Text

Typical Usage:
  - Used by: Person, Patient, Employee
  - Cardinality: Single value (one job title at a time)
  - Examples: "Financial Manager", "Software Engineer", "CEO"

Logseq Mapping:
  Schema.org Type: Text
  → Logseq Type: :default
  → Cardinality: :one (single value)
  → Module: person

Confidence: High ✅
```

### Step 2: Confirm Details

```
❓ Which module should this property go in?
   Suggested: person
   Other options: common, organization, [custom]

Module: [person] ▌

❓ What is the Logseq property type?
   Suggested: :default (text)
   Options:
     :default - Plain text
     :node - Link to another page/entity
     :date - Date picker
     :url - URL with validation
     :number - Numeric value

Type: [:default] ▌

❓ What is the cardinality?
   Suggested: :one (single value)
   Options:
     :one - Single value (most common)
     :many - Multiple values (list)

Cardinality: [:one] ▌

❓ Which classes should have this property?
   Suggested based on Schema.org:
     [x] Person
     [x] Patient
     [ ] Employee (doesn't exist yet)
     [ ] Organization (already has different job properties)

   Other classes:
     [ ] Thing
     [ ] CreativeWork
     [ ] ... (132 more)

Classes: [Person, Patient] ▌

❓ Add icon emoji?
   Suggested: 💼 (briefcase)
   Other suggestions: 👔 🏢 📊

Icon: [💼] ▌

❓ Add description?
   Suggested: "The job title of the person"

Description: [The job title of the person] ▌
```

### Step 3: Generate Property Definition

```
📝 Generating property definition...

Will create:
  - Property: jobTitle
  - ID: user.property/jobTitle-xyz789
  - Type: :default
  - Cardinality: :one
  - Classes: Person, Patient
  - Module: source/person/

Preview:
```clojure
{:user.property/jobTitle-xyz789
 {:db/cardinality :db.cardinality/one
  :logseq.property/type :default
  :block/title "jobTitle"
  :build/property-classes
  [:user.class/Person-abc123
   :user.class/Patient-def456]
  :build/properties
  {:logseq.property/icon {:id "briefcase" :type :emoji}
   :logseq.property/description "The job title of the person"}}}
```

Continue? [Y/n]: ▌
```

### Step 4: Update Module Files

```
📁 Updating module files...

Editing source/person/properties.edn:
  + Added jobTitle property definition
  + Added to properties map
  ✓ Valid EDN syntax

Editing source/person/README.md:
  + Added jobTitle to property list
  + Added example: #Person with jobTitle "Software Engineer"
  ✓ Updated

Updating class definitions:
  source/person/classes.edn:
    + Added :user.property/jobTitle-xyz789 to Person class
    + Added :user.property/jobTitle-xyz789 to Patient class
  ✓ Classes updated

Module updated! ✅
```

### Step 5: Build & Validate

```
🔨 Building all variants...

Building variants:
  [████████████] full      ✓ (8,939 lines, +5)
  [████████████] crm       ✓ (5,394 lines, +5)
  [████████████] research  ✓ (4,203 lines, no change)
  [████████████] content   ✓ (3,902 lines, no change)
  [████████████] events    ✓ (2,801 lines, no change)

✅ All builds successful!

🔍 Validating...
  ✓ EDN structure valid
  ✓ Property counts correct (full: 335, crm: 241)
  ✓ Class counts correct
  ✓ No duplicate IDs
  ✓ All referenced classes exist

✅ Validation passed!

Impact:
  • Variants affected: full, crm
  • New property: jobTitle
  • Classes updated: Person, Patient
  • Total additions: +5 lines to affected variants
```

### Step 6: Review Changes

```
📊 Summary of Changes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files Modified:
  source/person/properties.edn (+7 lines)
  source/person/classes.edn (+2 lines)
  source/person/README.md (+3 lines)

Git diff summary:
  +12 lines added
  -0 lines removed
  3 files changed

View full diff? [y/N]: ▌
```

### Step 7: Generate Commit

```
📝 Suggested commit message:

feat(properties): add jobTitle property to Person and Patient

- Added jobTitle property (text, single value)
- Associated with Person and Patient classes
- Schema.org compliant
- Affects variants: full, crm

Use this message? [Y/n]: ▌
```

If approved:
```
✓ Staged changes
✓ Created commit
✓ Commit message validated (conventional commits)

Ready to push! Use:
  git push
```

---

## Advanced Type Mapping

### Example: Duration Properties (cookTime)

```
🔍 Researching "cookTime"...

Found: https://schema.org/cookTime

Expected Type: Duration
Description: Time to cook the dish (e.g., "PT30M" for 30 minutes)

⚠️  Duration type requires special handling:

  Schema.org uses ISO 8601 duration format:
    - "PT30M" = 30 minutes
    - "PT1H" = 1 hour
    - "PT1H30M" = 1 hour 30 minutes

  Logseq mapping options:
    1. :default (text) - Store as "PT30M" string
    2. :default (text) - Store as "30 minutes" human-readable
    3. :number - Store minutes as number (30)

Recommended: Option 1 (:default with ISO 8601)
  → Standardized format
  → Easy to parse programmatically
  → Schema.org compliant

Choose mapping: [1/2/3]: ▌
```

### Example: Node/Relationship Properties (author)

```
🔍 Researching "author"...

Found: https://schema.org/author

Expected Type: Person or Organization
Description: The author of this content

This is a **relationship property** (links to other entities)

Logseq mapping:
  Schema.org Type: Person | Organization
  → Logseq Type: :node (relationship)
  → Cardinality: :many (multiple authors possible)
  → Target Types: Person, Organization

Configuration:
  Type: :node ✓
  Cardinality: :many ✓
  Can link to: Person pages, Organization pages
```

### Example: Enumeration Properties (eventStatus)

```
🔍 Researching "eventStatus"...

Found: https://schema.org/eventStatus

Expected Type: EventStatusType (Enumeration)
Description: An eventStatus of an event represents its status

Possible values from Schema.org:
  - EventScheduled
  - EventCancelled
  - EventMovedOnline
  - EventPostponed
  - EventRescheduled

Logseq mapping:
  Schema.org Type: Enumeration
  → Logseq Type: :default (with predefined choices)
  → Cardinality: :one (single status)

❓ Should we add predefined choices?
   [Y/n]: y

Choices will be added to property schema:
  - "Scheduled"
  - "Cancelled"
  - "Moved Online"
  - "Postponed"
  - "Rescheduled"

(Simplified for user-friendliness)
```

---

## Property Type Reference

### Complete Type Mapping Table

| Schema.org Type | Logseq Type | Cardinality | Notes |
|-----------------|-------------|-------------|-------|
| **Text** | `:default` | Usually `:one` | Plain text |
| **URL** | `:url` | Usually `:one` | URL with validation |
| **Date** | `:date` | Usually `:one` | Date picker |
| **DateTime** | `:date` | Usually `:one` | Date + time picker |
| **Number** | `:number` | Usually `:one` | Numeric value |
| **Integer** | `:number` | Usually `:one` | Whole number |
| **Boolean** | `:default` | `:one` | Use checkbox or yes/no |
| **Duration** | `:default` | `:one` | ISO 8601 format (PT30M) |
| **Person** | `:node` | Often `:many` | Link to Person pages |
| **Organization** | `:node` | Often `:many` | Link to Organization pages |
| **Thing** | `:node` | Varies | Link to any entity |
| **Enumeration** | `:default` | `:one` | With predefined choices |
| **QuantitativeValue** | `:number` | `:one` | Or `:default` with unit |

### Cardinality Guidelines

**Use `:one` (single value) for:**
- Unique identifiers (email, ISBN)
- Singular attributes (birthDate, jobTitle)
- Status fields (eventStatus, orderStatus)
- Counts and measurements (price, duration)

**Use `:many` (multiple values) for:**
- Collections (children, employees, skills)
- Lists (authors, attendees, ingredients)
- Tags and categories (keywords, genres)
- Relationships (spouse, knows, memberOf)

The command suggests cardinality based on Schema.org usage patterns.

---

## Advanced Options

### Specify Module Explicitly

```
/new-property jobTitle --module=person

Skips module selection prompt.
```

### Specify Type Explicitly

```
/new-property jobTitle --type=default

Skips type selection prompt.
Options: default, node, date, url, number
```

### Specify Cardinality Explicitly

```
/new-property jobTitle --cardinality=one

Skips cardinality selection prompt.
Options: one, many
```

### Skip Schema.org Research

```
/new-property customProperty --no-research

Creates property without Schema.org lookup.
Use for project-specific properties.
```

### Add to Specific Classes

```
/new-property jobTitle --classes=Person,Patient,Employee

Adds property to specified classes only.
```

### Dry Run (Preview Only)

```
/new-property jobTitle --dry-run

Shows what would be created without making changes.
```

---

## Error Handling

### Property Already Exists

```
❌ Property "jobTitle" already exists!

Found in: source/person/properties.edn
ID: user.property/jobTitle-abc123
Type: :default
Cardinality: :one
Classes: Person

Options:
  1. View existing property: /show-property jobTitle
  2. Edit existing property: /edit-property jobTitle
  3. Choose different name: [title, position, role, etc.]
  4. Add to more classes: /add-property-to-class jobTitle Class

What would you like to do? ▌
```

### Schema.org Not Found

```
⚠️  "customWidget" not found on Schema.org

This might be a project-specific property.

Manual configuration required:
  Type: [default/node/date/url/number] ▌
  Cardinality: [one/many] ▌
  Classes: [list classes] ▌

Continue? [y/N]: ▌
```

### Type Mismatch Warning

```
⚠️  Type mismatch detected!

Schema.org specifies: Organization (object)
You selected: :default (text)

This means:
  - Schema.org expects: Link to Organization entity
  - Your choice: Plain text field

Recommendation: Use :node type for relationships

Options:
  1. Change to :node (recommended)
  2. Keep :default (store as text)
  3. Cancel and reconsider

Choose: [1/2/3] ▌
```

### Class Doesn't Exist

```
❌ Class "Employee" not found

You specified Employee class, but it doesn't exist in the template.

Options:
  1. Create Employee class first: /new-class Employee
  2. Remove from class list
  3. Choose different classes

What would you like to do? ▌
```

---

## Examples

### Example 1: Simple Text Property

```bash
/new-property jobTitle

→ Researches schema.org/jobTitle
→ Maps to :default (text)
→ Suggests :one (single value)
→ Adds to Person, Patient
→ Creates property
→ Builds and validates
→ Commits
→ Done in ~3 minutes
```

### Example 2: Relationship Property (Multiple Values)

```bash
/new-property alumniOf

→ Researches schema.org/alumniOf
→ Maps to :node (Organization)
→ Suggests :many (multiple schools)
→ Adds to Person
→ Creates property
→ Done
```

### Example 3: Date Property

```bash
/new-property birthDate

→ Researches schema.org/birthDate
→ Maps to :date
→ Suggests :one
→ Adds to Person, Patient
→ Creates with date picker
→ Done
```

### Example 4: Enumeration Property

```bash
/new-property eventStatus

→ Researches schema.org/eventStatus
→ Detects enumeration type
→ Lists possible values
→ Creates with predefined choices
→ Done
```

### Example 5: Custom Property (Not in Schema.org)

```bash
/new-property internalNotes --no-research

Manual configuration:
  Module: common
  Type: :default
  Cardinality: :one
  Classes: Thing (available to all)

→ Creates custom property
→ Done
```

---

## Integration with Other Commands

Works well with:
- `/new-class` - Add properties while creating class
- `/edit-property` - Modify property later
- `/test-workflow` - Test after adding property
- `/stats` - See updated property counts
- `/release-prep` - Include in next release

---

## Tips

1. **Research First** - Schema.org provides best practices
2. **Choose Type Carefully** - Type changes later are disruptive
3. **Cardinality Matters** - `:one` vs `:many` affects storage
4. **Use Relationships** - `:node` type for entity links
5. **Add Descriptions** - Help users understand the property
6. **Test in Logseq** - Import and verify behavior

---

## Time Savings

**Manual Process:**
1. Research Schema.org (3 min)
2. Determine type mapping (2 min)
3. Create property in Logseq (2 min)
4. Associate with classes (3 min)
5. Export and split (2 min)
6. Build variants (2 min)
7. Validate (2 min)
8. Commit (2 min)
**Total: ~18 minutes**

**With /new-property:**
1. Run command
2. Answer prompts
3. Review and confirm
**Total: ~3 minutes**

**Saves: 15 minutes (83% reduction)**

---

## Related Commands

- `/new-class` - Add new class
- `/edit-property` - Modify existing property
- `/show-property` - View property details
- `/test-workflow` - Test changes
- `/stats` - View project statistics
- `/release-prep` - Prepare release

---

## Learn More

- [Schema.org Properties](https://schema.org/docs/properties.html)
- [EDN Format](https://github.com/edn-format/edn)
- [Technical Reference](../../docs/architecture/technical-reference.md#properties)
- [Property Types](../../docs/architecture/technical-reference.md#edn-file-format)
