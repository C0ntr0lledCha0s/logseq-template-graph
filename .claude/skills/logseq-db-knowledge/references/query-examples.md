# Logseq DB Query Examples

A comprehensive cookbook of Datalog queries for Logseq DB graphs.

## CRITICAL: Query Format for Logseq DB

**Every query in Logseq DB MUST start with `{:query` and end with `}`**

**Correct format:**
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Task]]}
```

**Common mistakes (DON'T DO THESE):**
```clojure
; ❌ WRONG - Extra {{query}} wrapper (old syntax)
{{query
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]]}
}}

; ❌ WRONG - Missing {:query ...} wrapper
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]]
```

### Convention in This Document

**IMPORTANT:** Query examples below show the **datalog structure** for learning purposes.

**When copying to Logseq DB, you MUST wrap every query like this:**
```clojure
{:query THE_EXAMPLE_QUERY_HERE}
```

For example, if you see:
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]]
```

You must write in Logseq:
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]]}
```

## Query Basics

### Query Structure

All queries in Logseq DB follow this structure:
```clojure
{:query [:find FIND-CLAUSE
         :where WHERE-CLAUSES]}
```

**Pull Pattern** (get entity data):
```clojure
{:query [:find (pull ?variable [*])
         :where
         [?variable :attribute value]]}
```

**Specific Attributes**:
```clojure
{:query [:find (pull ?b [:block/title :block/content])
         :where
         [?b :block/tags ?t]]}
```

## Finding Nodes by Tag

### Find All Tasks
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Task]]}
```

### Find All Journals
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Journal]]}
```

### Find All Queries
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Query]]}
```

### Find All Cards (Flashcards)
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Card]]}
```

### Find All Custom Tagged Nodes

Replace `Person` with your custom tag name:
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Person]]}
```

### Find Nodes with Multiple Tags

Find nodes tagged with BOTH `Person` AND `Author`:
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t1]
         [?t1 :db/ident :logseq.class/Person]
         [?b :block/tags ?t2]
         [?t2 :db/ident :logseq.class/Author]]}
```

## Task Queries

### Tasks by Status

**Find TODO tasks:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Todo"]]
```

**Find DOING tasks:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Doing"]]
```

**Find DONE tasks:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Done"]]
```

**Find tasks NOT done:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title ?status]
 [(not= ?status "Done")]
 [(not= ?status "Canceled")]]
```

### Tasks by Priority

**Find high priority (A) tasks:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/priority ?p]
 [?p :block/title "A"]]
```

**Find tasks with any priority:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/priority ?p]]
```

### Tasks by Deadline

**Find tasks with deadline today:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/deadline ?d]
 [(= ?d 20241119)]]  ; Replace with today's date YYYYMMDD
```

**Find overdue tasks:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/deadline ?d]
 [(< ?d 20241119)]   ; Replace with today's date YYYYMMDD
 [?b :logseq.property/status ?s]
 [?s :block/title ?status]
 [(not= ?status "Done")]
 [(not= ?status "Canceled")]]
```

**Find tasks due this week:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/deadline ?d]
 [(>= ?d 20241118)]  ; Start of week
 [(<= ?d 20241124)]] ; End of week
```

### Combined Task Filters

**High priority TODO tasks:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Todo"]
 [?b :logseq.property/priority ?p]
 [?p :block/title "A"]]
```

**DOING tasks with deadlines:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Doing"]
 [?b :logseq.property/deadline ?d]]
```

## Property Queries

### Find Nodes with Specific Property Value

**Text property:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/email "john@example.com"]]
```

**Number property:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/age 25]]
```

**Node property (reference):**
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/author ?author]
 [?author :block/title "John Doe"]]
```

### Find Nodes with Any Value for a Property

```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/birthday ?date]]
```

### Find Nodes with Empty Property

This is tricky - you find all nodes WITHOUT the property:
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Person]
 (not [?b :logseq.property/email ?e])]
```

### Range Queries on Number Properties

**Greater than:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/age ?age]
 [(> ?age 30)]]
```

**Between:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/score ?score]
 [(>= ?score 70)]
 [(<= ?score 90)]]
```

### Date Range Queries

**After a date:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/created ?date]
 [(> ?date 20240101)]]
```

**Between dates:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/event-date ?date]
 [(>= ?date 20241101)]
 [(<= ?date 20241130)]]
```

## Content and Text Queries

### Find Blocks Containing Text

**Case-sensitive:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/content ?content]
 [(clojure.string/includes? ?content "history")]]
```

**Case-insensitive:**
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/content ?content]
 [(clojure.string/lower-case ?content) ?lower]
 [(clojure.string/includes? ?lower "history")]]
```

### Find Blocks Matching Regex

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/content ?content]
 [(re-find #"TODO.*urgent" ?content)]]
```

### Find Blocks by Title

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/title "Exact Title"]]
```

### Find Blocks with Title Containing

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/title ?title]
 [(clojure.string/includes? ?title "partial")]]
```

## Reference Queries

### Find Blocks Referencing a Specific Page

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/refs ?ref]
 [?ref :block/title "Target Page"]]
```

### Find Blocks Referenced By a Specific Page

```clojure
[:find (pull ?ref [*])
 :where
 [?b :block/title "Source Page"]
 [?b :block/refs ?ref]]
```

### Find Blocks with Any References

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/refs ?ref]]
```

### Find Blocks Without References

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/content ?c]
 (not [?b :block/refs ?ref])]
```

## Hierarchy Queries

### Find All Child Blocks of a Page

```clojure
[:find (pull ?b [*])
 :where
 [?page :block/title "Parent Page"]
 [?b :block/page ?page]]
```

### Find Direct Children of a Block

```clojure
[:find (pull ?child [*])
 :where
 [?parent :block/title "Parent Block"]
 [?child :block/parent ?parent]]
```

### Find Top-Level Blocks of a Page

```clojure
[:find (pull ?b [*])
 :where
 [?page :block/title "My Page"]
 [?b :block/page ?page]
 [?b :block/parent ?page]]
```

## Journal Queries

### Today's Journal

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/journal-day 20241119]]  ; Replace with today YYYYMMDD
```

### Journal Date Range

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/journal? true]
 [?b :block/journal-day ?date]
 [(>= ?date 20241101)]
 [(<= ?date 20241130)]]
```

### All Journal Pages

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/journal? true]]
```

### Blocks on Today's Journal

```clojure
[:find (pull ?b [*])
 :where
 [?journal :block/journal-day 20241119]  ; Today
 [?b :block/page ?journal]]
```

## Aggregation Queries

### Count Nodes by Tag

```clojure
[:find (count ?b)
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]]
```

### Count Tasks by Status

```clojure
[:find ?status (count ?b)
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title ?status]]
```

### Sum Number Properties

```clojure
[:find (sum ?hours)
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/estimated-hours ?hours]]
```

### Average Number Properties

```clojure
[:find (avg ?score)
 :where
 [?b :logseq.property/score ?score]]
```

### Min and Max

```clojure
[:find (min ?date) (max ?date)
 :where
 [?b :block/journal-day ?date]]
```

## Sorting and Limiting

### Sort by Property (Ascending)

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Person]
 [?b :logseq.property/age ?age]
 :order-by [(asc ?age)]]
```

### Sort by Property (Descending)

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/updated-at ?updated]
 :order-by [(desc ?updated)]]
```

### Limit Results

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 :limit 10]
```

### Latest 5 Journal Pages

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/journal? true]
 [?b :block/journal-day ?date]
 :order-by [(desc ?date)]
 :limit 5]
```

## Advanced Patterns

### Union (OR Logic)

Find blocks tagged with EITHER Person OR Company:
```clojure
[:find (pull ?b [*])
 :where
 (or
   (and [?b :block/tags ?t]
        [?t :db/ident :logseq.class/Person])
   (and [?b :block/tags ?t]
        [?t :db/ident :logseq.class/Company]))]
```

### Negation (NOT Logic)

Find tasks that are NOT done:
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 (not [?b :logseq.property/status ?s]
      [?s :block/title "Done"])]
```

### Recursive Queries (Tag Hierarchy)

Find all nodes with a tag or any child tag:
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?tag]
 (or
   [?tag :db/ident :logseq.class/MediaObject]
   (and [?tag :logseq.class/parent ?parent]
        [?parent :db/ident :logseq.class/MediaObject]))]
```

### Joins Across Entities

Find tasks assigned to people in a specific city:
```clojure
[:find (pull ?task [*])
 :where
 [?task :block/tags ?task-class]
 [?task-class :db/ident :logseq.class/Task]
 [?task :logseq.property/assigned-to ?person]
 [?person :logseq.property/city "New York"]]
```

## Custom Property Queries

### Books with Authors

```clojure
[:find (pull ?book [:block/title :logseq.property/author])
 :where
 [?book :block/tags ?t]
 [?t :db/ident :logseq.class/Book]
 [?book :logseq.property/author ?author]]
```

### People Who Are Authors

```clojure
[:find (pull ?person [*])
 :where
 [?person :block/tags ?t]
 [?t :db/ident :logseq.class/Person]
 [?book :logseq.property/author ?person]]
```

### Projects with Tasks

```clojure
[:find (pull ?project [*])
 :where
 [?project :block/tags ?proj-tag]
 [?proj-tag :db/ident :logseq.class/Project]
 [?task :block/tags ?task-tag]
 [?task-tag :db/ident :logseq.class/Task]
 [?task :logseq.property/project ?project]]
```

## Flashcard Queries

### Cards Due Today

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Card]
 [?b :logseq.property/due ?due]
 [(<= ?due 1699891200000)]]  ; Replace with current timestamp
```

### New Cards (Never Reviewed)

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Card]
 (not [?b :logseq.property/due ?d])]
```

## Timestamps and Dates

### Created This Week

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/created-at ?created]
 [(>= ?created 1699833600000)]  ; Start of week timestamp
 [(<= ?created 1700438399000)]] ; End of week timestamp
```

### Updated Today

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/updated-at ?updated]
 [(>= ?updated 1699833600000)]] ; Today's start timestamp
```

### Most Recently Updated

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/updated-at ?updated]
 :order-by [(desc ?updated)]
 :limit 20]
```

## Template Queries

### Find All Templates

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Template]]
```

### Templates for Specific Tag

```clojure
[:find (pull ?template [*])
 :where
 [?template :block/tags ?template-tag]
 [?template-tag :db/ident :logseq.class/Template]
 [?template :logseq.property/apply-template-to-tags ?target]
 [?target :db/ident :logseq.class/Journal]]
```

## Asset Queries

### All Assets

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Asset]]
```

### Assets of Specific Type (Images)

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Asset]
 [?b :block/content ?content]
 [(clojure.string/includes? ?content ".png")]]
```

## Query Debugging Tips

### Test Query in Parts

Start simple and build up:
```clojure
; Step 1: Find the tag
[:find ?t
 :where
 [?t :db/ident :logseq.class/Task]]

; Step 2: Find nodes with tag
[:find ?b
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]]

; Step 3: Add property filter
[:find ?b
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]]

; Step 4: Pull full data
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Doing"]]
```

### Inspect Individual Entity

```clojure
[:find (pull ?b [*])
 :where
 [?b :block/uuid #uuid "your-uuid-here"]]
```

### List All Property Names

```clojure
[:find ?prop-name
 :where
 [?prop :block/type :property]
 [?prop :block/title ?prop-name]]
```

### List All Tags

```clojure
[:find ?tag-name
 :where
 [?tag :db/ident ?ident]
 [(namespace ?ident) ?ns]
 [(= ?ns "logseq.class")]
 [?tag :block/title ?tag-name]]
```

## Common Pitfalls

### DON'T: Use :block/marker for DB Tasks
```clojure
; This doesn't work in DB graphs!
[:find (pull ?b [*])
 :where
 [?b :block/marker "TODO"]]
```

### DO: Use tag + property
```clojure
[:find (pull ?b [*])
 :where
 [?b :block/tags ?t]
 [?t :db/ident :logseq.class/Task]
 [?b :logseq.property/status ?s]
 [?s :block/title "Todo"]]
```

### DON'T: Assume properties are strings
```clojure
; Wrong - status is a reference!
[:find (pull ?b [*])
 :where
 [?b :logseq.property/status "Doing"]]
```

### DO: Follow the reference
```clojure
[:find (pull ?b [*])
 :where
 [?b :logseq.property/status ?s]
 [?s :block/title "Doing"]]
```

## Using Queries in Logseq DB

### Query Format

**Every query MUST use this format:**
```clojure
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :db/ident :logseq.class/Task]]}
```

No `{{query}}` wrapper - just `{:query ...}`.

### Recommended: Use Query Builder

Instead of writing queries manually:
1. Type `/Query` in a block
2. Use visual interface to select tag and filters
3. Logseq generates correct syntax automatically

This is the easiest way to avoid syntax errors!

## Additional Resources

- See `data-model.md` for complete attribute reference
- Logseq documentation: https://docs.logseq.com
- Datascript documentation: https://github.com/tonsky/datascript
