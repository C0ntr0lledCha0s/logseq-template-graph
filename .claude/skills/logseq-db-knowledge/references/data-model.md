# Logseq DB Data Model Reference

This document provides a detailed technical reference for the Logseq DB data model.

## Entity-Attribute-Value (EAV) Model

Logseq DB uses a Datascript database, which follows the Entity-Attribute-Value model. Understanding this is crucial for effective querying.

### Basic Structure

Every fact in the database is a triple:
```
[Entity, Attribute, Value]
[123, :block/content, "My note"]
```

## Core Entities

### Blocks (Nodes)

Blocks are the fundamental entity in Logseq DB. Both traditional "blocks" and "pages" are stored as block entities.

**Essential Attributes:**
```clojure
:block/uuid         ; UUID - Unique identifier (string)
:db/id              ; Long - Internal database ID
:block/title        ; String - Title (for pages and named blocks)
:block/content      ; String - Text content
:block/page         ; Ref - Parent page reference
:block/parent       ; Ref - Parent block reference
:block/left         ; Ref - Left sibling block reference
:block/created-at   ; Long - Creation timestamp (ms since epoch)
:block/updated-at   ; Long - Last update timestamp (ms since epoch)
```

**Relationship Attributes:**
```clojure
:block/tags         ; Ref (multi) - New tags on this node
:block/refs         ; Ref (multi) - Referenced nodes
:block/path-refs    ; Ref (multi) - All refs including parent hierarchy
```

**Property Attributes:**
```clojure
:block/properties   ; Map - All properties (structured differently than file-based)
:logseq.property/*  ; Specific property namespaces (varies by property)
```

**Type Indicators:**
```clojure
:block/type         ; Keyword - Entity type (:node, :property, :class, etc.)
:block/format       ; Keyword - Content format (:markdown, etc.)
```

### Pages

Pages are blocks with special characteristics:

**Page-Specific Attributes:**
```clojure
:block/title        ; String - Page name (REQUIRED for pages)
:block/journal?     ; Boolean - Is this a journal page?
:block/journal-day  ; Long - Journal date (YYYYMMDD format)
```

**Page Uniqueness:**
Pages are made unique by their title AND tags. The database allows:
- `Apple` with `#Company` tag
- `Apple` with `#Fruit` tag

Both can coexist as separate pages.

### Properties (Property Pages)

Properties themselves are entities:

**Property Attributes:**
```clojure
:block/title              ; String - Property name
:block/schema             ; Map - Property configuration
  {:type :default         ; Property type
   :cardinality :one      ; Single or multiple values
   :classes [...]         ; Allowed tags for node properties
   :values [...]          ; Predefined choices
   :position :block       ; UI position
   :hide? false}          ; Hide by default?
:logseq.property/icon     ; String - Property icon
```

**Property Types:**
- `:default` - Text
- `:number` - Number
- `:date` - Date
- `:datetime` - DateTime
- `:checkbox` - Boolean
- `:url` - URL
- `:node` - Node reference

**Property Schema Example:**
```clojure
{:type :node
 :cardinality :many
 :classes [:logseq.class/Person]
 :position :block
 :hide? false}
```

### Classes (New Tags)

Classes (new tags) are special entities that define structure:

**Class Attributes:**
```clojure
:db/ident                    ; Keyword - Canonical identifier
                            ; Example: :logseq.class/Task
:block/title                 ; String - Display name
:logseq.class/parent         ; Ref (multi) - Parent classes (Extends)
:logseq.class/properties     ; Ref (multi) - Tag properties
```

**Built-in Classes:**
```clojure
:logseq.class/Root          ; Root of all classes
:logseq.class/Task          ; Tasks
:logseq.class/Journal       ; Journal pages
:logseq.class/Query         ; Queries
:logseq.class/Card          ; Flashcards
:logseq.class/Template      ; Templates
:logseq.class/Asset         ; Assets
:logseq.class/Code          ; Code blocks
:logseq.class/Quote         ; Quote blocks
:logseq.class/Math          ; Math blocks
```

**Custom Classes:**
You can create any class, e.g., `:logseq.class/Person`, `:logseq.class/Project`

### Tagged Nodes (Objects)

When a node has a new tag, it becomes a "tagged node" or "object":

**Tagged Node Structure:**
```clojure
; The node
{:db/id 456
 :block/title "John Doe"
 :block/content "John Doe"
 :block/tags [789]           ; References to class entities
 :logseq.property/email "john@example.com"
 :logseq.property/birthday 20241115}

; The tag/class it references
{:db/id 789
 :db/ident :logseq.class/Person
 :block/title "Person"
 :logseq.class/properties [101, 102]}  ; email and birthday properties
```

## Property Storage

Properties in Logseq DB are stored with namespaced attributes:

### Property Attribute Pattern
```clojure
:logseq.property/PROPERTY-NAME
```

### Examples:
```clojure
:logseq.property/status      ; Status property (for tasks)
:logseq.property/priority    ; Priority property
:logseq.property/deadline    ; Deadline property
:logseq.property/email       ; Custom "email" property
:logseq.property/author      ; Custom "author" property
```

### Property Value Types

**Text Property:**
```clojure
[?b :logseq.property/description "Some text"]
```

**Number Property:**
```clojure
[?b :logseq.property/age 25]
```

**Node Property (Reference):**
```clojure
[?b :logseq.property/author ?author]
[?author :block/title "John Doe"]
```

**Date Property:**
```clojure
[?b :logseq.property/birthday 20241115]  ; YYYYMMDD format
```

**DateTime Property:**
```clojure
[?b :logseq.property/due 1699891200000]  ; Timestamp in ms
```

**Multiple Values:**
```clojure
; If cardinality is :many
[?b :logseq.property/tags "tag1"]
[?b :logseq.property/tags "tag2"]
[?b :logseq.property/tags "tag3"]
```

## Tasks in Detail

Tasks are nodes tagged with `:logseq.class/Task`:

**Task Entity Structure:**
```clojure
{:db/id 123
 :block/uuid #uuid "..."
 :block/content "Write documentation"
 :block/tags [?task-class]
 :logseq.property/status [?status-choice]
 :logseq.property/priority [?priority-choice]
 :logseq.property/deadline 20241120
 :logseq.property/scheduled 20241118}
```

**Status Property:**
The status is stored as a reference to a choice entity:
```clojure
; Query pattern
[?task :logseq.property/status ?status]
[?status :block/title "Doing"]

; Status choices (built-in)
"Backlog"
"Todo"
"Doing"
"In Review"
"Done"
"Canceled"
```

**Status History:**
Status changes are tracked (queryable through advanced queries):
```clojure
:logseq.task/status-history
; Contains: [{:status "Todo" :timestamp 123456789}
;            {:status "Doing" :timestamp 123456999}]
```

## Journals in Detail

Journal pages are tagged with `:logseq.class/Journal`:

**Journal Entity:**
```clojure
{:db/id 456
 :block/title "Aug 29th, 2024"
 :block/journal? true
 :block/journal-day 20240829
 :block/tags [?journal-class]}
```

**Natural Language References:**
When you write `[[Today]]`, Logseq resolves it to the journal page for the current date.

## Queries in Detail

Query entities are tagged with `:logseq.class/Query`:

**Query Entity:**
```clojure
{:db/id 789
 :block/content "(task DOING)"
 :block/tags [?query-class]
 :logseq.property/query-string "(task DOING)"
 :logseq.property/query-type :simple}  ; or :advanced
```

## Property Choices

Properties can have predefined choices (like enums):

**Property with Choices:**
```clojure
; Status property
{:block/title "Status"
 :block/schema {:type :default
                :values [{:value "Backlog" :icon "📋"}
                        {:value "Todo" :icon "📝"}
                        {:value "Doing" :icon "⚙️"}
                        {:value "Done" :icon "✅"}]}}
```

**Choice Values in Nodes:**
Choices are stored as references:
```clojure
[?task :logseq.property/status ?choice]
[?choice :block/title "Doing"]
```

## Relationships and Hierarchy

### Block Hierarchy

Blocks are organized in a tree structure:

```
Page
  ├─ Block 1 (:block/parent → Page, :block/left → nil)
  │   ├─ Block 1.1 (:block/parent → Block 1, :block/left → nil)
  │   └─ Block 1.2 (:block/parent → Block 1, :block/left → Block 1.1)
  └─ Block 2 (:block/parent → Page, :block/left → Block 1)
```

**Attributes for Hierarchy:**
- `:block/parent` - Direct parent (page or block)
- `:block/left` - Previous sibling
- `:block/page` - Root page (even for nested blocks)

### Tag Hierarchy

Classes can have parent classes:

```
Root Tag
  ├─ Task
  │   └─ ProjectTask (Extends: Task)
  └─ MediaObject
      └─ AudioBook (Extends: MediaObject, Book)
```

**Attributes:**
- `:logseq.class/parent` - Parent classes (multi-valued)

### References

References connect nodes:

```clojure
; Direct reference
[?b :block/refs ?ref]
[?ref :block/title "Anthropology"]

; Path references (includes parent page refs)
[?b :block/path-refs ?path-ref]
```

## Common Query Patterns

### Find All Nodes of a Type

```clojure
; Find all tasks
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]]
```

### Filter by Property

```clojure
; Find tasks with high priority
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/priority ?p]
 [?p :block/title "A"]]
```

### Search by Content

```clojure
; Find blocks containing text
[:find (pull ?b [*])
 :where
 [?b :block/content ?content]
 [(clojure.string/includes? ?content "keyword")]]
```

### Get Tagged Nodes with Tag Properties

```clojure
; Find all people with their properties
[:find (pull ?b [:block/title
                  :logseq.property/email
                  :logseq.property/birthday])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Person]]
```

### Navigate References

```clojure
; Find all blocks that reference a specific page
[:find (pull ?b [*])
 :where
 [?b :block/refs ?ref]
 [?ref :block/title "Target Page"]]
```

### Query with Joins

```clojure
; Find tasks assigned to specific person
[:find (pull ?task [*])
 :where
 [?task :block/tags ?task-class]
 [?task-class :db/ident :logseq.class/Task]
 [?task :logseq.property/assigned-to ?person]
 [?person :block/title "John Doe"]]
```

## Data Types in Datascript

Understanding Datascript types helps with queries:

**Scalar Types:**
- String: `"text"`
- Long: `123456`
- Double: `3.14`
- Boolean: `true` / `false`
- Keyword: `:keyword`
- UUID: `#uuid "..."`

**Reference Type:**
- Ref: Entity ID reference (Long)
- Multi-valued refs: Multiple entity references

**Date/Time:**
- Dates: Stored as Long in YYYYMMDD format: `20241115`
- DateTimes: Stored as Long (ms since epoch): `1699891200000`

## Performance Considerations

### Indexed Attributes

Most Logseq attributes are indexed for fast querying:
- `:block/title`
- `:block/tags`
- `:block/refs`
- `:logseq.property/*` (property namespaces)
- `:db/ident`

### Query Optimization Tips

1. **Filter by tag first** - Most selective
```clojure
[?b :block/tags ?t]
[?t :db/ident :logseq.class/Task]
; Then add more filters
```

2. **Use pull patterns** - Get only what you need
```clojure
[:find (pull ?b [:block/title :logseq.property/status])
 :where ...]
```

3. **Avoid unbounded queries** - Always filter
```clojure
; BAD - gets everything
[:find (pull ?b [*])
 :where [?b :block/content]]

; GOOD - filters first
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Person]]
```

## Schema Evolution

Logseq DB schema can change between versions:

**Schema Version Attribute:**
```clojure
:logseq.schema/version
:logseq.schema/initial-version
```

When the schema changes, Logseq automatically migrates data. Always backup before upgrading!

## Export Format (EDN)

Graphs can be exported as EDN (Extensible Data Notation):

**EDN Structure:**
```clojure
{:version 1
 :blocks [{:db/id 1
           :block/uuid #uuid "..."
           :block/title "My Page"
           :block/tags [2 3]}
          {:db/id 2
           :db/ident :logseq.class/Page}
          ...]
 :schema {...}}
```

Use Logseq CLI: `logseq export-edn` for exports.

## Summary

Key takeaways for the Logseq DB data model:

1. **Everything is a block** (pages, blocks, properties, classes)
2. **Attributes are namespaced** (`:logseq.property/name`, `:logseq.class/Type`)
3. **References are entities** (property values, tags, choices)
4. **Queries use Datalog** (EAV pattern matching)
5. **Schema defines structure** (property types, cardinality, validation)
6. **Hierarchy is explicit** (parent/child via refs, not file paths)

For practical examples, see `query-examples.md`.
