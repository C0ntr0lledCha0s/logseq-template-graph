# Logseq DB vs File-based: Complete Comparison

This guide helps you understand the critical differences between Logseq DB (database) graphs and file-based (markdown) graphs.

## Quick Decision Guide

**Use Logseq DB if:**
- Starting a new graph
- Want structured data with types and validation
- Need powerful property-based workflows
- Want built-in tables and views
- Prefer visual data management

**Use File-based Logseq if:**
- Already have an established markdown graph
- Need direct file system access
- Want version control on individual files
- Prefer plain text portability
- Use external markdown tools

## Fundamental Differences

### Storage Model

| Aspect | File-based | Logseq DB |
|--------|-----------|-----------|
| **Storage** | Markdown files | SQLite database (Datascript) |
| **Pages** | Individual .md files | Database entities |
| **Blocks** | Markdown text | Database entities with relationships |
| **Editing** | Direct file modification | Database transactions |
| **Version Control** | Git-friendly (text files) | Database file (less git-friendly) |
| **Portability** | Plain markdown | EDN export required |

### Data Structure

**File-based:**
```markdown
- TODO This is a task #tag
  status:: DOING
  - Child block
```

**Logseq DB:**
```
Database entities with typed properties:
Block {
  :block/content "This is a task"
  :block/tags [#Task]
  :logseq.property/status → "Doing" (reference to choice)
  :block/parent → (reference to parent block)
}
```

## Tasks: The Biggest Difference

### File-based Tasks

**Markers:**
```markdown
- TODO Task in backlog
- DOING Working on this
- DONE Completed task
- CANCELED Won't do
```

**Properties (optional):**
```markdown
- TODO Review document
  priority:: A
  deadline:: [[Dec 1st, 2024]]
```

**Queries:**
```clojure
; Find DOING tasks
[:find (pull ?b [*])
 :where
 [?b :block/marker "DOING"]]
```

### Logseq DB Tasks

**Tags + Properties (required):**
```
Task block tagged with #Task
Status: Doing (property with choices)
Priority: A (property with choices)
Deadline: 2024-12-01 (date property)
```

**No markers - everything is properties!**

**Queries:**
```clojure
; Find Doing tasks
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Doing"]]
```

### Migration Notes

When importing file-based → DB:
- `TODO` becomes `Status: Todo` + `#Task` tag
- `DOING` becomes `Status: Doing` + `#Task` tag
- `DONE` becomes `Status: Done` + `#Task` tag
- `NOW/LATER` becomes `Status: Backlog/Todo`

**Your old queries WILL break!** You must rewrite them.

## Tags: Simple vs Structured

### File-based Tags

**Simple hashtags:**
```markdown
- This is about #history and #research
- Meeting with #John
```

**No structure:** Tags are just text labels

**No inheritance:** Each block's tags are independent

**Use case:** Lightweight organization and filtering

### Logseq DB New Tags

**Structured classes:**
```
#Person (class with properties: email, birthday)
  - John Doe #Person
    email: john@example.com
    birthday: 1990-05-15
```

**Inheritance via Extends:**
```
#Book (property: author)
  └─ #AudioBook (property: narrator)
     └─ Inherits both: author + narrator
```

**Tag properties:**
All nodes with `#Person` automatically get `email` and `birthday` properties

**Use case:** Structured data modeling, CRM, project management

## Properties: Frontmatter vs Database

### File-based Properties

**Frontmatter (pages):**
```markdown
---
title: My Page
author: John Doe
tags: research, history
---

Page content here
```

**Inline properties (blocks):**
```markdown
- Meeting notes
  attendees:: [[Alice]], [[Bob]]
  date:: [[Oct 15th, 2024]]
  status:: completed
```

**Characteristics:**
- Properties are strings (untyped)
- No validation
- Manual consistency
- Limited UI support

### Logseq DB Properties

**Typed properties:**
- Text, Number, Date, DateTime, Checkbox, Url, Node
- Built-in validation
- Consistent UI (pickers, dropdowns)
- Property choices (enums)

**Example:**
```
Person page #Person
  email: john@example.com (Url type - validated)
  birthday: 1990-05-15 (Date type - date picker)
  age: 34 (Number type - sorts correctly)
```

**Tag properties:**
Add property to `#Person` tag → all people inherit it automatically

**Property configuration:**
- Default values
- Multiple values
- UI position (inline, below, beginning, end)
- Hide by default
- Property choices

## Pages: Files vs Entities

### File-based Pages

**Unique by name:**
- Only one "Apple" page possible
- Use namespaces: `Apple/Company`, `Apple/Fruit`

**File location:**
```
pages/
  Apple.md
  Apple_Company.md  (namespace)
  Apple_Fruit.md    (namespace)
```

**References:**
```markdown
[[Apple]]
[[Apple/Company]]
```

### Logseq DB Pages

**Unique by tag:**
- `Apple #Company` (one page)
- `Apple #Fruit` (different page)
- Both coexist with same base name

**Database storage:**
```
Block {id: 1, title: "Apple", tags: [#Company]}
Block {id: 2, title: "Apple", tags: [#Fruit]}
```

**References:**
```
[[Apple #Company]]
[[Apple #Fruit]]
[[Apple]] (shows picker if multiple exist)
```

**Conversion:**
Blocks can become pages by adding `#Page` tag

## Blocks: Similar But Different

### Both Versions

**Common features:**
- Nested hierarchy
- References `[[]]`
- Block embeds
- Outlining

### File-based

**Storage:**
```markdown
- Parent block
  - Child block 1
  - Child block 2
    - Grandchild
```

**Block references:**
```markdown
- ((block-uuid))
```

**Attributes:**
- `:block/marker` (TODO, DOING, etc.)
- `:block/priority` (A, B, C)
- `:block/properties` (map of property strings)

### Logseq DB

**Storage:**
Database entities with explicit parent/sibling refs:
```
Block {parent: page-id, left: nil}
  Block {parent: parent-block-id, left: nil}
  Block {parent: parent-block-id, left: previous-sibling-id}
```

**Block references:**
```
[[Block name]] or ((uuid))
```

**Attributes:**
- `:block/tags` (references to tag classes)
- `:logseq.property/*` (typed properties)
- No `:block/marker` (use Status property instead!)

## Queries: Major Syntax Differences

### Finding Tasks

**File-based:**
```clojure
; All TODO tasks
[:find (pull ?b [*])
 :where
 [?b :block/marker "TODO"]]

; High priority tasks
[:find (pull ?b [*])
 :where
 [?b :block/marker "TODO"]
 [?b :block/priority "A"]]
```

**Logseq DB:**
```clojure
; All Todo tasks
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Todo"]]

; High priority tasks
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Todo"]
 [?b :logseq.property/priority ?p]
 [?p :block/title "A"]]
```

### Finding Tagged Nodes

**File-based:**
```clojure
; Blocks with #research tag
[:find (pull ?b [*])
 :where
 [?b :block/refs ?ref]
 [?ref :block/title "research"]]
```

**Logseq DB:**
```clojure
; Nodes with #Research tag (as a class)
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Research]]

; Or if research is just inline text (not a class)
[:find (pull ?b [*])
 :where
 [?b :block/content ?content]
 [(clojure.string/includes? ?content "#research")]]
```

### Property Queries

**File-based:**
```clojure
; Find blocks with status property
[:find (pull ?b [*])
 :where
 [?b :block/properties ?props]
 [(get ?props :status) ?status]
 [(= ?status "done")]]
```

**Logseq DB:**
```clojure
; Find nodes with status property
[:find (pull ?b [*])
 :where
 [?b :logseq.property/status ?s]
 [?s :block/title "Done"]]
```

**Key difference:** DB properties are references to entities, not strings!

## Journals

### File-based

**Storage:**
```
journals/
  2024_10_15.md
  2024_10_16.md
```

**Content:**
```markdown
- Meeting with team
- TODO Review report
- #project/alpha update
```

**Natural language:**
```markdown
[[Today]]
[[Tomorrow]]
[[Yesterday]]
```

### Logseq DB

**Storage:**
Database entities with:
```
:block/journal? true
:block/journal-day 20241015
:block/tags [#Journal]
```

**Content:**
Same outlining and references

**Natural language:**
```
[[Today]]
[[Next Friday]]
[[Last Monday]]
```

**Enhanced date picker:**
- Type natural language: "next week"
- Converts to journal date
- More flexible than file-based

## Templates

### File-based

**Create:**
```markdown
- template:: meeting-notes
  - Attendees::
  - Agenda::
  - Notes::
  - Action items::
```

**Use:**
Type `/template` and select

**Limitations:**
- Manual insertion only
- No auto-application

### Logseq DB

**Create:**
```
Meeting Notes #Template
  Attendees:
  Agenda:
  Notes:
  Action items:
```

**Use:**
- Type `/template` and select
- **Or auto-apply:** Set `Apply template to tags` property

**Auto-apply example:**
```
Daily Standup #Template
  Apply template to tags: #Journal
```
Now every journal page automatically has this template!

**Powerful for:**
- Daily journal templates
- Task templates
- Meeting templates
- Any tag-based workflow

## Views and Tables

### File-based

**Query results:**
```
{{query (and [[research]] (task TODO))}}
```
Shows as list or table

**Query format:** Simple syntax, uses TODO markers
```
(task TODO)
(and [[page]] (task DOING))
```

**Limitations:**
- Read-only views
- Manual query writing
- Limited formatting

### Logseq DB

**Built-in tables:**
Every tag page has a "Tagged Nodes" table:
- Sortable by any property
- Filterable
- Create new nodes directly in table
- Bulk actions on selected rows

**Query format:** Advanced queries use {:query ...} map (NOT {{query}})
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Task]
         [?b :logseq.property/status ?s]
         [?s :block/title "Doing"]]}
```

**Recommendation:** Use Query Builder (`/Query` command) instead of writing raw queries

**Views:**
- Table view (default)
- Gallery view (for assets)
- Custom views (future)

**Example:**
Navigate to `#Task` page → see all tasks in sortable table → create new task inline

**Use case:** Visual data management without writing queries

## Search

### File-based

**Full-text search:**
Search bar finds text in markdown files

**Limitations:**
- Text matching only
- No property filtering in search UI
- No structured filters

### Logseq DB

**Search commands:**
- Natural language: "tasks due this week"
- Property filters built into search
- Tag-based filtering

**Enhanced search:**
- Semantic search (AI-powered)
- Structured queries via UI
- Command palette improvements

## Import and Export

### File-based

**Import:**
- Copy markdown files to directory
- Reference external markdown

**Export:**
- Files are already portable
- Copy directory anywhere
- Use in any markdown tool

**Backup:**
- Git repository (recommended)
- Cloud sync (Dropbox, iCloud)
- Simple file copy

### Logseq DB

**Import:**
- DB Graph Importer (converts file-based → DB)
- Converts TODO markers to #Task tags
- Imports properties to typed properties

**Export:**
- EDN format (`logseq export-edn`)
- Markdown export (lossy - loses structure)

**Backup:**
- Automated backup (built-in, enabled by default)
- Manual: Copy database file
- EDN export for archival

**Portability:**
- Less portable than markdown
- Requires Logseq or EDN parser
- Can't edit in external tools

## Performance

### File-based

**Pros:**
- Fast file operations
- Scales to thousands of files
- External tools (grep, find) work well

**Cons:**
- Large graphs slow down
- Complex queries are slow
- File system limitations

### Logseq DB

**Pros:**
- Fast database queries
- Indexed lookups
- Efficient for large graphs
- Complex queries are fast

**Cons:**
- Database overhead
- Single large file (not distributed)
- Requires database maintenance

## Collaboration

### File-based

**Pros:**
- Git merge conflicts manageable (text files)
- External diff tools work
- Multiple collaborators can edit different files

**Cons:**
- Manual conflict resolution
- No real-time collaboration

### Logseq DB

**Pros:**
- Future: Better sync support planned
- Atomic transactions

**Cons:**
- Database conflicts harder to resolve
- Limited git-based collaboration
- Binary file format

## Migration Path

### File-based → Logseq DB

**Using DB Graph Importer:**
1. Open Logseq Desktop
2. Go to Settings → Import
3. Select "DB Graph Importer"
4. Choose your file-based graph
5. Review conversion settings
6. Import

**What gets converted:**
- Pages → Pages (entities)
- Blocks → Blocks (entities)
- TODO/DOING markers → #Task tag + Status property
- Properties → Typed properties (best effort)
- Tags → Inline tags or new tags (configurable)
- References → References (preserved)

**What requires manual work:**
- **All queries** - Must rewrite with new syntax
- Custom workflows using markers
- Scripts accessing markdown files

**Recommendation:** Test on a COPY first!

### Logseq DB → File-based

**Options:**
1. EDN export → manual conversion (difficult)
2. Markdown export (lossy, loses structure)

**What gets lost:**
- Typed properties → become strings
- New tag structure → become simple tags
- Property choices → become plain text
- Task Status property → might convert to markers (unreliable)

**Recommendation:** Not recommended unless necessary

## Common Pitfalls When Switching

### From File-based to DB

❌ **Expecting TODO markers to work**
- File: `- TODO Task`
- DB: Must use `#Task` tag + Status property

❌ **Assuming queries still work**
- File: `[?b :block/marker "TODO"]`
- DB: Must query by tag and property

❌ **Treating tags as simple labels**
- DB: Tags are classes with properties and structure

❌ **Manual property management**
- DB: Use tag properties for consistency

### From DB to File-based

❌ **Expecting structured properties**
- DB: Typed, validated properties
- File: All properties are strings

❌ **Relying on property choices**
- DB: Dropdown with predefined choices
- File: Free-form text

❌ **Using tag properties**
- DB: Tag properties inherited by all tagged nodes
- File: Each block's properties are independent

## Feature Comparison Table

| Feature | File-based | Logseq DB |
|---------|-----------|-----------|
| **Storage** | Markdown files | SQLite database |
| **Tasks** | TODO/DOING markers | #Task tag + properties |
| **Properties** | Untyped strings | Typed + validated |
| **Tags** | Simple labels | Classes with structure |
| **Tables** | Query results only | Built-in, editable tables |
| **Page uniqueness** | By name only | By name + tag |
| **Templates** | Manual insert | Manual + auto-apply |
| **Export** | Already portable | Requires EDN export |
| **Git friendly** | Very | Not very |
| **Query speed** | Slower (large graphs) | Faster (indexed) |
| **Learning curve** | Easier | Steeper |
| **External tools** | Many | Few |
| **Type safety** | None | Strong |
| **Bulk actions** | Manual | Table UI |
| **Property inheritance** | No | Via tag properties |

## Recommendation

**Start new graphs with Logseq DB** unless:
- You need plain markdown portability
- You collaborate heavily via git
- You use external markdown tools
- You prefer simplicity over structure

**Stay with file-based** if:
- You have an established workflow
- Your graph is simple (< 1000 pages)
- You don't need structured data
- You want maximum portability

**Migrate to DB** if:
- You need typed properties
- You want visual data management (tables)
- You have complex workflows
- You're willing to rewrite queries
- You want property-based automation

## Summary

The key mental shift:

**File-based = Markdown files with lightweight metadata**
- Simple, portable, text-based
- Properties are strings
- Tasks use markers
- Tags are labels

**Logseq DB = Structured database with rich types**
- Powerful, typed, relational
- Properties are entities
- Tasks use classes
- Tags are schemas

Choose based on your needs: portability vs. power.
