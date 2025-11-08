# Create New Schema.org Class

Interactive workflow to add a new class to the template with Schema.org integration.

This is an **enhanced version** of `/add-class` with better research, validation, and automation.

## What This Does

1. **Research Schema.org** - Fetches class definition, properties, hierarchy
2. **Interactive Planning** - Asks which module, parent class, properties
3. **Generate Class Definition** - Creates EDN with proper structure
4. **Update Module** - Adds to source module files
5. **Build & Validate** - Tests all variants
6. **Generate Commit** - Creates conventional commit message
7. **Documentation** - Suggests doc updates

## Usage

```
/new-class [ClassName]
```

**Examples:**
```bash
/new-class Recipe
/new-class MedicalCondition
/new-class SoftwareApplication
/new-class JobPosting
```

## Interactive Workflow

### Step 1: Research Schema.org

```
🔍 Researching Schema.org for "Recipe"...

Found: https://schema.org/Recipe

📋 Class Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Name: Recipe
Description: A recipe. For dietary restrictions covered by the recipe,
            a few common restrictions are enumerated via suitableForDiet.
Parent: CreativeWork
Category: Creative work / How-to content

Properties (15 found):
  ✓ recipeIngredient (Text, many) - ingredient used in the recipe
  ✓ recipeInstructions (Text, one) - steps to make the dish
  ✓ cookTime (Duration, one) - time to cook (e.g., "PT30M")
  ✓ prepTime (Duration, one) - time to prepare
  ✓ totalTime (Duration, one) - total time (prep + cook)
  ✓ recipeYield (Text, one) - quantity produced (e.g., "4 servings")
  ✓ recipeCuisine (Text, one) - cuisine type (e.g., "Italian")
  ✓ recipeCategory (Text, one) - category (e.g., "Dessert")
  ✓ nutrition (NutritionInformation, one) - nutritional info
  ✓ suitableForDiet (RestrictedDiet, many) - diet restrictions
  ✓ author (Person/Organization, many) - recipe author
  ✓ datePublished (Date, one) - publication date
  ✓ image (URL, many) - images
  ✓ video (VideoObject, one) - video instructions
  ✓ keywords (Text, many) - tags/keywords

Suggested Module: creative-work
```

### Step 2: Confirm Details

```
❓ Where should this class go?
   Suggested: creative-work
   Other options: misc, [custom]

Module: [creative-work] ▌

❓ What is the parent class?
   Suggested: CreativeWork (from Schema.org)
   Other options: Thing, [custom]

Parent: [CreativeWork] ▌

❓ Which properties should we include?
   [ ] All 15 properties (recommended)
   [x] Essential only (7 properties)
   [ ] Custom selection

Properties: [Essential] ▌

Essential properties selected:
  - recipeIngredient
  - recipeInstructions
  - cookTime
  - prepTime
  - totalTime
  - recipeYield
  - author

❓ Add icon emoji?
   Suggested: 🍳 (cooking)
   Other suggestions: 🍴 👨‍🍳 🥘

Icon: [🍳] ▌

❓ Add description?
   Suggested: "A recipe for cooking or baking"

Description: [A recipe for cooking or baking] ▌
```

### Step 3: Generate Class Definition

```
📝 Generating class definition...

Will create:
  - Class: Recipe
  - ID: user.class/Recipe-xyz789
  - Parent: user.class/CreativeWork-abc123
  - Properties: 7 (will be created if not exist)
  - Module: source/creative-work/

Preview:
```clojure
{:user.class/Recipe-xyz789
 {:block/title "Recipe"
  :build/class-properties
  [:user.property/recipeIngredient-id1
   :user.property/recipeInstructions-id2
   :user.property/cookTime-id3
   :user.property/prepTime-id4
   :user.property/totalTime-id5
   :user.property/recipeYield-id6
   :user.property/author-id7]
  :build/class-parent :user.class/CreativeWork-abc123
  :build/properties
  {:logseq.property/icon {:id "cooking" :type :emoji}
   :logseq.property/description "A recipe for cooking or baking"}}}
```

Continue? [Y/n]: ▌
```

### Step 4: Create Properties (if needed)

```
🔧 Checking properties...

Existing properties:
  ✓ author (already exists in common/)

New properties needed (6):
  → recipeIngredient (Text, many)
  → recipeInstructions (Text, one)
  → cookTime (Text, one)
  → prepTime (Text, one)
  → totalTime (Text, one)
  → recipeYield (Text, one)

Create these properties? [Y/n]: y

Creating properties...
  ✓ recipeIngredient → source/creative-work/properties.edn
  ✓ recipeInstructions → source/creative-work/properties.edn
  ✓ cookTime → source/creative-work/properties.edn
  ✓ prepTime → source/creative-work/properties.edn
  ✓ totalTime → source/creative-work/properties.edn
  ✓ recipeYield → source/creative-work/properties.edn

All properties ready! ✅
```

### Step 5: Update Module Files

```
📁 Updating module files...

Editing source/creative-work/classes.edn:
  + Added Recipe class definition
  + Added to classes map
  ✓ Valid EDN syntax

Editing source/creative-work/README.md:
  + Added Recipe to class list
  + Added example usage
  ✓ Updated

Module updated! ✅
```

### Step 6: Build & Validate

```
🔨 Building all variants...

Building variants:
  [████████████] full      ✓ (8,956 lines, +25)
  [████████████] crm       ✓ (5,389 lines, no change)
  [████████████] research  ✓ (4,203 lines, no change)
  [████████████] content   ✓ (3,927 lines, +25)
  [████████████] events    ✓ (2,801 lines, no change)

✅ All builds successful!

🔍 Validating...
  ✓ EDN structure valid
  ✓ Property counts correct (full: 340, content: 157)
  ✓ Class counts correct (full: 136, content: 41)
  ✓ No duplicate IDs
  ✓ All parent classes exist

✅ Validation passed!

Impact:
  • Variants affected: full, content
  • New class: Recipe
  • New properties: 6
  • Total additions: +25 lines to full variant
```

### Step 7: Review Changes

```
📊 Summary of Changes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Files Modified:
  source/creative-work/classes.edn (+12 lines)
  source/creative-work/properties.edn (+13 lines)
  source/creative-work/README.md (+5 lines)

Git diff summary:
  +30 lines added
  -0 lines removed
  3 files changed

View full diff? [y/N]: ▌
```

If user wants to see diff:
```bash
git diff source/creative-work/
```

### Step 8: Generate Commit

```
📝 Suggested commit message:

feat(classes): add Recipe class to creative-work module

- Added Recipe class with 7 properties
- Properties: recipeIngredient, recipeInstructions, cookTime,
  prepTime, totalTime, recipeYield, author
- Parent class: CreativeWork
- Schema.org compliant
- Affects variants: full, content

Related: #42

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

### Step 9: Documentation Suggestions

```
📚 Documentation Updates Suggested
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Consider updating:
  1. docs/architecture/technical-reference.md
     → Add Recipe to CreativeWork examples

  2. QUICK_START.md
     → Add Recipe to feature showcase

  3. source/creative-work/README.md
     → Already updated ✓

Update these now? [y/N]: ▌
```

If user approves, AI updates documentation.

---

## Advanced Options

### Custom Property Selection

```
/new-class Recipe

❓ Which properties should we include?
   [ ] All 15 properties
   [ ] Essential only (7 properties)
   [x] Custom selection

Select properties to include:
  [x] recipeIngredient (Text, many)
  [x] recipeInstructions (Text, one)
  [x] cookTime (Text, one)
  [ ] prepTime (Text, one)
  [ ] totalTime (Text, one)
  [x] recipeYield (Text, one)
  [ ] recipeCuisine (Text, one)
  [ ] recipeCategory (Text, one)
  [ ] nutrition (Node, one)
  [ ] suitableForDiet (Node, many)
  [x] author (Node, many)
  [ ] datePublished (Date, one)
  [ ] image (URL, many)
  [ ] video (Node, one)
  [ ] keywords (Text, many)

Use ↑/↓ to navigate, Space to toggle, Enter to confirm
```

### Specify Module Explicitly

```
/new-class Recipe --module=creative-work

Skips module selection prompt.
```

### Specify Parent Explicitly

```
/new-class Recipe --parent=CreativeWork

Skips parent class selection prompt.
```

### Skip Schema.org Research

```
/new-class CustomClass --no-research

Creates class without Schema.org lookup.
Use for project-specific classes not in Schema.org.
```

### Dry Run (Preview Only)

```
/new-class Recipe --dry-run

Shows what would be created without making changes.
```

---

## Error Handling

### Class Already Exists

```
❌ Class "Recipe" already exists!

Found in: source/creative-work/classes.edn
ID: user.class/Recipe-abc123

Options:
  1. Edit existing class: /edit-class Recipe
  2. Choose different name: [RecipeInstruction, CookingRecipe, etc.]
  3. Delete and recreate: [dangerous!]

What would you like to do? ▌
```

### Schema.org Not Found

```
⚠️  "CustomWidget" not found on Schema.org

This might be a project-specific class.

Options:
  1. Continue without Schema.org (manual property definition)
  2. Search with different name
  3. Browse Schema.org: https://schema.org/

Continue? [y/N]: ▌
```

### Module Doesn't Exist

```
❌ Module "custom-module" not found

Available modules:
  - base
  - person
  - organization
  - event
  - creative-work
  - place
  - product
  - intangible
  - action
  - health
  - misc
  - common

Create new module "custom-module"? [y/N]: ▌
```

### Parent Class Not Found

```
❌ Parent class "CustomParent" not found

Available classes:
  - Thing (root)
  - Person
  - Organization
  - CreativeWork
  - Event
  - Place
  ... (132 more)

Search for class? [parent name]: ▌
```

### Build Failure

```
❌ Build failed after adding Recipe class

Error in source/creative-work/classes.edn:
  Invalid EDN syntax at line 42

Rolling back changes...
  ✓ Reverted classes.edn
  ✓ Reverted properties.edn
  ✓ Reverted README.md

Changes rolled back. Fix the error and try again.

Debug with: /diagnose full
```

---

## Property Type Mapping

When creating properties, Schema.org types are mapped to Logseq:

| Schema.org Type | Logseq Type | Cardinality |
|-----------------|-------------|-------------|
| Text | `:default` | Usually `:one` |
| URL | `:url` | Usually `:one` |
| Date, DateTime | `:date` | Usually `:one` |
| Number, Integer | `:number` | Usually `:one` |
| Duration | `:default` | `:one` (text like "PT30M") |
| Boolean | `:default` | `:one` |
| Person, Organization | `:node` | Often `:many` |
| Thing (any object) | `:node` | Varies |
| Enumeration | `:default` | `:one` (with options) |

The command intelligently suggests types and cardinality based on Schema.org definitions.

---

## Examples

### Example 1: Recipe Class

```bash
/new-class Recipe

→ Researches schema.org/Recipe
→ Suggests creative-work module
→ Parent: CreativeWork
→ 15 properties found
→ Selects 7 essential properties
→ Creates class + properties
→ Builds and validates
→ Commits with proper message
→ Done in ~5 minutes (vs 20+ manually)
```

### Example 2: MedicalCondition Class

```bash
/new-class MedicalCondition

→ Researches schema.org/MedicalCondition
→ Suggests health module
→ Parent: MedicalEntity
→ 25 properties found
→ Asks which to include
→ Creates class definition
→ Links to existing health properties
→ Validates medical terminology
→ Done
```

### Example 3: Custom Class (Not in Schema.org)

```bash
/new-class MyCustomClass --no-research

⚠️  Skipping Schema.org research

Manual configuration:
  Module: [misc] ▌
  Parent: [Thing] ▌
  Properties: [manually enter] ▌

→ Creates custom class
→ Manual property definition
→ Validates structure
→ Done
```

---

## Integration with Other Commands

This command works well with:
- `/new-property` - Add more properties later
- `/test-workflow` - Test after creating class
- `/stats` - See updated class counts
- `/release-prep` - Include in next release

---

## Tips

1. **Research First** - Always check Schema.org for standard naming
2. **Start Essential** - Add core properties first, extend later
3. **Use Presets** - "Essential" vs "All" property selection
4. **Validate Often** - Command validates at each step
5. **Commit Atomic** - One class per commit for clarity
6. **Document** - Update README.md and docs as suggested

---

## Time Savings

**Manual Process:**
1. Research Schema.org (5 min)
2. Create class in Logseq (3 min)
3. Add properties manually (7 min)
4. Export and split (2 min)
5. Build variants (2 min)
6. Validate (2 min)
7. Update docs (3 min)
8. Commit (2 min)
**Total: ~26 minutes**

**With /new-class:**
1. Run command
2. Answer prompts
3. Review and confirm
**Total: ~5 minutes**

**Saves: 21 minutes (81% reduction)**

---

## Related Commands

- `/new-property` - Add individual property
- `/edit-class` - Modify existing class
- `/test-workflow` - Test changes
- `/stats` - View project statistics
- `/release-prep` - Prepare release

---

## Learn More

- [Schema.org](https://schema.org/) - Standard vocabulary
- [EDN Format](https://github.com/edn-format/edn) - Data notation
- [Technical Reference](../../docs/architecture/technical-reference.md)
- [CI/CD Pipeline](../../docs/developer-guide/ci-cd-pipeline.md)
