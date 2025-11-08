# Feature-Complete Agent

**Type:** Autonomous Agent
**Purpose:** End-to-end workflow for adding new classes or properties to the template
**Autonomy Level:** High (with user confirmation at key steps)
**Estimated Time Savings:** 20-30 minutes per feature

---

## Agent Overview

The `feature-complete` agent handles the entire workflow of adding a new class or property to the Logseq template, from initial research through final commit. It combines the functionality of `/new-class` and `/new-property` with additional automation for building, testing, and documentation.

**Key Difference from Commands:**
- Commands are interactive prompts
- Agents are autonomous workflows with decision logic
- This agent can make intelligent decisions and recover from errors

---

## Capabilities

### 1. Research & Planning
- Fetches Schema.org definitions
- Analyzes class hierarchies
- Suggests parent classes and modules
- Identifies related properties
- Detects potential conflicts

### 2. Implementation
- Generates EDN definitions
- Creates/updates source files
- Updates module READMEs
- Manages UUIDs and IDs
- Validates syntax

### 3. Building & Validation
- Builds all 5 template variants
- Validates EDN structure
- Checks for regressions
- Compares before/after metrics
- Detects anomalies

### 4. Documentation
- Updates technical documentation
- Adds examples
- Updates module README
- Suggests user guide updates

### 5. Commit & Release
- Generates conventional commit messages
- Validates commit format
- Stages appropriate files
- Prepares for push

### 6. Error Recovery
- Rolls back on failures
- Suggests fixes
- Retries with corrections
- Escalates to user when stuck

---

## Workflow

### Phase 1: Initialize

```
User: "Add Recipe class"

Agent Thinks:
  - Type: Class addition
  - Name: Recipe
  - Action: Research Schema.org

Agent Actions:
  1. Fetch https://schema.org/Recipe
  2. Parse class definition
  3. Identify parent (CreativeWork)
  4. Find related properties (15 found)
  5. Suggest module (creative-work)

Agent Reports:
  "Found Recipe on Schema.org. Parent: CreativeWork.
   15 properties available. Suggests creative-work module.

   Proceed with standard workflow? [Y/n]"
```

### Phase 2: Plan

```
Agent Plans:
  ✓ Module: creative-work
  ✓ Parent: CreativeWork
  ✓ Properties: 7 essential (recipeIngredient, cookTime, etc.)
  ✓ New properties needed: 6 (author already exists)
  ✓ Affected variants: full, content

Agent Confirms:
  "Plan:
   - Add Recipe to creative-work module
   - Create 6 new properties
   - Reuse 1 existing property (author)
   - Will affect: full, content variants

   Continue? [Y/n]"
```

### Phase 3: Implement

```
Agent Executes:
  1. Generate class EDN ✓
  2. Generate 6 property EDNs ✓
  3. Update source/creative-work/classes.edn ✓
  4. Update source/creative-work/properties.edn ✓
  5. Update source/creative-work/README.md ✓
  6. Validate all EDN syntax ✓

Agent Reports:
  "Implementation complete.
   Files modified: 3
   Lines added: 30
   Validation: PASS

   Proceed to build? [Y/n]"
```

### Phase 4: Build & Validate

```
Agent Builds:
  1. npm run build:full ✓ (8,956 lines, +25)
  2. npm run build:crm ✓ (no change)
  3. npm run build:research ✓ (no change)
  4. npm run build:content ✓ (3,927 lines, +25)
  5. npm run build:events ✓ (no change)

Agent Validates:
  - EDN structure: ✓
  - Property counts: ✓
  - Class counts: ✓
  - No duplicates: ✓
  - Parents exist: ✓

Agent Reports:
  "All builds successful.
   Validation passed.
   Variants affected: full (+25 lines), content (+25 lines)

   Proceed to commit? [Y/n]"
```

### Phase 5: Document (Optional)

```
Agent Suggests:
  "Documentation updates recommended:
   1. Add Recipe example to QUICK_START.md
   2. Update docs/architecture/technical-reference.md
   3. Module README already updated ✓

   Update docs now? [y/N]"

If user confirms:
  Agent Updates:
    - Adds Recipe example to appropriate docs
    - Updates property list
    - Regenerates any auto-generated content
```

### Phase 6: Commit

```
Agent Commits:
  Message:
    feat(classes): add Recipe class to creative-work module

    - Added Recipe class with 7 properties
    - Properties: recipeIngredient, recipeInstructions, cookTime,
      prepTime, totalTime, recipeYield, author
    - Parent class: CreativeWork
    - Schema.org compliant
    - Affects variants: full, content

  Files:
    source/creative-work/classes.edn
    source/creative-work/properties.edn
    source/creative-work/README.md

Agent Reports:
  "Committed successfully.

   Next steps:
   - Test import in Logseq
   - Push to remote: git push
   - Or add more features

   Done! Recipe class ready to use."
```

---

## Decision Logic

### Module Selection

```
If class in Schema.org:
  If class parent is Person → module = person
  Else if class parent is Organization → module = organization
  Else if class parent is Event → module = event
  Else if class parent is CreativeWork → module = creative-work
  Else if class parent is Place → module = place
  Else if class parent is Product → module = product
  Else if class parent is Intangible → module = intangible
  Else if class parent is Action → module = action
  Else if health-related → module = health
  Else → module = misc

Else:
  Ask user for module
```

### Property Creation Strategy

```
For each property in Schema.org:

  If property exists in common/:
    Reuse existing property

  Else if property exists in another module:
    If property is generic (e.g., "name", "description"):
      Move to common/
      Update all references
    Else:
      Ask user: reuse or duplicate?

  Else:
    Create new property in module

  Property type mapping:
    Schema.org Text → Logseq :default
    Schema.org URL → Logseq :url
    Schema.org Date/DateTime → Logseq :date
    Schema.org Number/Integer → Logseq :number
    Schema.org Person/Organization/Thing → Logseq :node
    Schema.org Enumeration → Logseq :default (with choices)
```

### Build Strategy

```
After implementation:

  Build all variants in parallel (if supported):
    full, crm, research, content, events

  For each build:
    If build succeeds:
      Run validation
      If validation fails:
        Report warnings
        Ask user to continue or fix

    Else if build fails:
      Parse error message
      Identify likely cause
      Suggest fix
      Ask user: fix manually or rollback?
```

### Error Recovery

```
On EDN syntax error:
  1. Parse error message
  2. Identify file and line
  3. Show context (5 lines before/after)
  4. Suggest fix based on common patterns
  5. Offer to fix automatically if confident
  6. Else ask user to fix manually

On build failure:
  1. Check if rollback is safe
  2. Offer rollback option
  3. Provide debug info
  4. Suggest /diagnose command
  5. Wait for user decision

On validation warning:
  1. Assess severity (error vs warning)
  2. If warning: report but continue
  3. If error: halt and suggest fix

On git conflict:
  1. Detect uncommitted changes
  2. Ask user: stash, commit, or cancel?
  3. Handle based on user choice
```

---

## User Interaction Points

The agent is autonomous but asks for confirmation at key decision points:

1. **Initial Plan** - Confirm module, parent, properties
2. **Build Decision** - Proceed to build after implementation?
3. **Documentation** - Update docs or skip?
4. **Commit Decision** - Approve commit message?
5. **Error Recovery** - How to handle failures?

**User can:**
- Approve (default, press Enter)
- Reject (type 'n' or 'no')
- Override (provide custom value)
- Cancel (Ctrl+C)

---

## Example Workflows

### Example 1: Simple Class Addition

```
User: "Add Recipe class"

Agent Workflow:
  1. Research → Schema.org found ✓
  2. Plan → creative-work module, CreativeWork parent ✓
  3. Confirm → User approves
  4. Implement → 3 files modified ✓
  5. Build → All variants ✓
  6. Validate → PASS ✓
  7. Commit → feat(classes): add Recipe class ✓

Time: ~3 minutes (vs 20+ minutes manually)
```

### Example 2: Property Addition with Conflict

```
User: "Add email property"

Agent Workflow:
  1. Research → Schema.org found ✓
  2. Check existing → email already exists! ⚠️
  3. Agent Reports:
     "Property 'email' already exists in common/properties.edn
      Used by: Person, Organization

      Options:
       1. Use existing (recommended)
       2. Create duplicate in different module
       3. Cancel

      Choose [1/2/3]:"

  4. User chooses: 1 (use existing)
  5. Agent adds email to more classes (if requested)
  6. Done (no new property needed)

Time: ~1 minute (conflict detected early)
```

### Example 3: Error Recovery

```
User: "Add CustomClass --no-research"

Agent Workflow:
  1. Skip research (as requested)
  2. Plan → Ask user for module, parent, properties
  3. Implement → User provides invalid EDN ✗
  4. Build fails → EDN syntax error detected
  5. Agent Reports:
     "Build failed: Invalid EDN syntax
      File: source/misc/classes.edn:42
      Error: Unexpected token '}'

      Context:
        40:   :block/title 'CustomClass'
        41:   :build/class-properties []
        42:   :build/properties {}  ← Missing closing brace
        43: }

      Suggested fix: Add closing brace after line 42

      Options:
       1. Fix automatically
       2. Fix manually (opens editor)
       3. Rollback changes

      Choose [1/2/3]:"

  6. User chooses: 1 (auto-fix)
  7. Agent fixes syntax
  8. Retries build → Success ✓
  9. Continue with validation and commit

Time: ~5 minutes (with error recovery)
```

---

## Integration with Commands

The agent can be invoked by commands or run standalone:

**Via Command:**
```
/new-class Recipe --agent

Delegates to feature-complete agent
```

**Standalone:**
```
/feature-complete add-class Recipe
/feature-complete add-property jobTitle
```

**Batch Mode:**
```
/feature-complete batch
  - Add Recipe
  - Add Book
  - Add Article

Processes multiple features in sequence
```

---

## Configuration

### Agent Settings

```clojure
{:agent/feature-complete
 {:autonomy :high              ; high, medium, low
  :confirm-steps [:plan        ; Which steps require confirmation
                  :commit]
  :auto-document false         ; Auto-update docs without asking
  :parallel-builds true        ; Build variants in parallel
  :rollback-on-error true      ; Auto-rollback on critical errors
  :research-timeout 30         ; Seconds to wait for Schema.org
  :build-timeout 120           ; Seconds to wait for builds
  :max-retries 2}}             ; Max retry attempts on failures
```

### Customization

Create `.claude/agents/feature-complete.config.edn` to override defaults.

---

## Performance

**Target Performance:**
- Simple class: 3-5 minutes
- Complex class (15+ properties): 5-8 minutes
- Property: 2-3 minutes
- Batch (5 classes): 15-20 minutes

**vs Manual:**
- Simple class: 20-25 minutes
- Complex class: 30-40 minutes
- Property: 15-20 minutes
- Batch (5 classes): 100-125 minutes

**Time Savings:** 75-85% reduction

---

## Limitations

1. **Cannot import to Logseq** - Manual testing still required
2. **Limited creativity** - Follows Schema.org patterns
3. **No merge conflict resolution** - Requires clean working tree
4. **Schema.org dependency** - Slower for custom classes
5. **Single-threaded** - One feature at a time (batch mode is sequential)

---

## Future Enhancements

1. **Intelligent batching** - Parallel feature addition
2. **Learning from history** - Suggest properties based on past choices
3. **Template generation** - Create preset configurations
4. **Integration testing** - Automated import tests
5. **Performance profiling** - Optimize build times

---

## Related

- `/new-class` - Manual class creation command
- `/new-property` - Manual property creation command
- `/test-workflow` - Test changes after agent completes
- `/stats` - View updated statistics
- `/release-prep` - Prepare release with new features

---

## Learn More

- [Claude Code Agents](https://docs.claude.com/en/docs/claude-code/agents)
- [Autonomous Workflows](../../docs/developer-guide/ci-cd-pipeline.md)
- [Technical Reference](../../docs/architecture/technical-reference.md)
