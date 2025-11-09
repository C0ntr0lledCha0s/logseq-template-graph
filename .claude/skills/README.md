# Claude Code Skills

This directory contains specialized skills that enhance Claude Code's capabilities for the Logseq Template Graph project.

## What Are Skills?

Skills are specialized prompts that give Claude Code deep expertise in specific domains. Unlike commands (which guide workflows), skills provide domain knowledge and analytical capabilities.

## Skill Structure

Each skill is a directory containing:
```
skill-name/
├── SKILL.md (required) - Main skill prompt with YAML frontmatter
├── reference.md (optional) - Additional documentation
├── examples.md (optional) - Usage examples
└── scripts/ (optional) - Helper utilities
```

## Available Skills

### 🔍 edn-analyzer

**Purpose:** Deep analysis of EDN template files

**Capabilities:**
- Count classes and properties
- Identify class hierarchies
- Find orphaned properties/classes
- Analyze cardinality distribution
- Check for duplicate IDs
- Generate structure reports
- Compare template variants

**When to use:**
- "Analyze the full template"
- "Find orphaned classes"
- "Compare CRM and full templates"
- "Show property type distribution"
- "Check for duplicate IDs"

**Example:**
```
You: "Analyze build/logseq_db_Templates_full.edn and show orphaned classes"

Claude activates edn-analyzer skill and provides:
- Complete template statistics
- List of orphaned classes with line numbers
- Suggestions for parent relationships
- Offer to fix issues automatically
```

---

### 📝 commit-helper

**Purpose:** Assist with conventional commit messages

**Capabilities:**
- Validate commit message format
- Suggest commit types based on changes
- Recommend appropriate scopes
- Generate multi-line commits with body/footer
- Check for common mistakes
- Ensure conventional commits compliance

**When to use:**
- "Suggest a commit message"
- "Help me write a commit"
- "Is this commit message valid?"
- "What type should this commit be?"

**Example:**
```
You: "Suggest a commit message for my changes"

Claude activates commit-helper skill and:
1. Analyzes staged changes with git diff
2. Determines appropriate type (feat, fix, docs, etc.)
3. Selects relevant scope (classes, properties, etc.)
4. Generates conventional commit message
5. Provides copy-pasteable command
```

---

### 🏥 module-health

**Purpose:** Assess modular architecture health

**Capabilities:**
- Analyze module size balance
- Check module cohesion
- Identify dependencies between modules
- Find orphaned files
- Calculate health scores
- Suggest reorganization
- Track improvements over time

**When to use:**
- "Check module health"
- "Is misc/ module too big?"
- "How should I reorganize modules?"
- "Show module statistics"
- "Which modules need attention?"

**Example:**
```
You: "Check module health and suggest improvements"

Claude activates module-health skill and provides:
- Overall health score (0-100)
- Per-module health scores
- Issues found (bloated modules, empty modules, etc.)
- Specific reorganization suggestions
- Effort estimates for improvements
```

---

### 🔬 schema-research

**Purpose:** Schema.org research and integration assistant

**Capabilities:**
- Fetch Schema.org class/property definitions
- Analyze class hierarchies and inheritance
- Map Schema.org types to Logseq types
- Determine property cardinality (:one vs :many)
- Check template for existing implementations
- Suggest module placement for new classes
- Recommend property additions for classes
- Provide real-world usage examples

**When to use:**
- "Research the Recipe class from Schema.org"
- "What properties are missing for Person?"
- "Should birthDate be :date or :default?"
- "Which classes should use 'location' property?"
- "Show hierarchy for MedicalCondition"
- "Where should I add the Event class?"

**Example:**
```
You: "Research the Recipe class before I add it to the template"

Claude activates schema-research skill and provides:
- Complete Schema.org definition and hierarchy
- All properties (inherited + direct)
- Template status check (parent class exists?)
- Module placement recommendation (creative-work/)
- Property type mappings (cookTime → :default)
- Cardinality decisions (recipeIngredient → :many)
- Integration steps and commit message
- Estimated implementation effort
```

---

### 📊 logseq-db-knowledge

**Purpose:** Comprehensive knowledge about Logseq DB (database) graphs syntax and concepts

**Capabilities:**
- Teach correct Logseq DB syntax (nodes, properties, tags, tasks, queries)
- Correct common misconceptions from file-based Logseq
- Provide accurate Datalog query patterns
- Explain DB-specific attributes and data model
- Guide on tag-based features (Tasks, Journals, Cards, etc.)
- Demonstrate proper query syntax ({:query ...} not {{query}})
- Clarify built-in vs custom tag matching (:db/ident vs :block/title)

**When to use:**
- "How do I query tasks in Logseq DB?"
- "Write a Datalog query to find all nodes tagged with #Person"
- "Why doesn't my TODO query work?"
- "What's the difference between file-based and DB Logseq?"
- "How do properties work in Logseq DB?"
- "Find all journal entries from last week"
- Working with Logseq queries and results don't match expectations

**Example:**
```
You: "Write a query to find all tasks with Doing status"

Claude activates logseq-db-knowledge skill and provides:

CORRECT (Logseq DB):
{:query [:find (pull ?b [*])
         :where
         [?b :block/tags ?t]
         [?t :block/title "Task"]
         [?b :logseq.property/status ?s]
         [?s :block/title "Doing"]]}

EXPLANATION:
- Tasks in DB use #Task tag (not TODO markers)
- Status is a property (not a block marker)
- Always use {:query ...} format (not {{query}})
- Use :block/title for tag matching (works universally)
```

**Critical Corrections:**
- ❌ File-based: `TODO`, `DOING`, `DONE` markers → ✅ DB: `#Task` + Status property
- ❌ Old syntax: `{{query}}` → ✅ New syntax: `{:query ...}`
- ❌ Custom tags: `:db/ident` → ✅ All tags: `:block/title`

**Reference Documentation:**
- [references/data-model.md](.claude/skills/logseq-db-knowledge/references/data-model.md) - DB schema and data model
- [references/query-examples.md](.claude/skills/logseq-db-knowledge/references/query-examples.md) - 50+ query examples
- [references/db-vs-file.md](.claude/skills/logseq-db-knowledge/references/db-vs-file.md) - Feature comparison guide

---

### 🐛 github-issues

**Purpose:** Intelligent GitHub issues management with validation and relationship tracking

**Capabilities:**
- Validate issues before responding (never assume reporter is correct)
- Search codebase/git history to verify bug reports
- Detect duplicate issues across open/closed states
- Map issue relationships (duplicates, blocked by, dependencies, etc.)
- Triage and label issues appropriately
- Generate implementation plans for valid features
- Create pull requests for simple fixes
- Request additional information when needed
- Track issue lifecycles from open to closed
- Update metadata fields automatically

**When to use:**
- "Validate issue #123"
- "Is this bug still present?"
- "Find duplicates of this issue"
- "Create implementation plan for #456"
- "What issues block #789?"
- "Respond to GitHub issue #42"
- "Check if Recipe class is already implemented"

**Example:**
```
You: "Validate issue #123 about Recipe class missing"

Claude activates github-issues skill and:
1. Reads the issue details
2. Searches codebase: grep -r "Recipe" source/
3. Checks git history: git log --grep="Recipe"
4. Searches closed issues for duplicates
5. Determines validation result:
   ✅ Valid - Recipe not found
   OR
   ❌ Invalid - Recipe exists in source/creative-work/classes.edn:45
6. Maps relationships (duplicates, related issues)
7. Responds with:
   - Validation results with evidence
   - Related issues list
   - Implementation plan OR
   - "Already implemented" with file locations
8. Updates labels and metadata
```

---

### 🔄 self-improvement

**Purpose:** Meta-learning skill that analyzes Claude Code's own performance and creates self-improving feedback loops

**Capabilities:**
- Analyze error patterns from git history
- Identify tool invocation failures and root causes
- Monitor CLAUDE.md size and structure health
- Suggest documentation extractions and optimizations
- Create automated feedback loops
- Track error recurrence and prevention success
- Extract learnings from successful patterns
- Generate improvement recommendations
- Build knowledge base from past mistakes

**When to use:**
- "Analyze why X failed"
- "How can we prevent this error?"
- "Is CLAUDE.md getting too bloated?"
- "What can we learn from this mistake?"
- "Check documentation health"
- "Review Claude Code performance"
- "Extract learnings from recent errors"
- After any significant error or failure

**Example:**
```
You: "The PowerShell hook failed. Can we improve the feedback loop?"

Claude activates self-improvement skill and:
1. Analyzes the error (emoji corruption in .ps1 file)
2. Classifies root cause (ENCODING issue)
3. Checks if preventable (Yes - no guidance existed)
4. Generates learning:
   - Error Pattern: PowerShell Emoji Corruption
   - Root Cause: Edit tool encoding issues
   - Solution: Use ASCII alternatives ([ERROR], [SUCCESS])
   - Prevention: Add PowerShell guidelines to CLAUDE.md
5. Implements improvement:
   - Adds PowerShell Script Guidelines section
   - Creates ASCII alternatives table
   - Documents pattern in skill's error catalog
   - Updates all affected scripts
6. Tracks metrics for future prevention
```

**Supporting Scripts:**
- `analyze-errors.sh/ps1` - Analyze error patterns from git history
- `claude-health-check.sh/ps1` - Check CLAUDE.md health metrics

---

### 📝 documentation-writer

**Purpose:** Expert technical writer for generating project documentation

**Capabilities:**
- Generate module READMEs from source code analysis
- Create user guides and step-by-step tutorials
- Write API documentation for scripts and functions
- Document commands, skills, and agent workflows
- Follow project style guides automatically
- Include tested code examples
- Add proper cross-references

**When to use:**
- "Document the person module"
- "Write a README for this feature"
- "Create a user guide for presets"
- "Document the build.clj script"
- "Write installation instructions"

**Example:**
```
You: "Document the person module"

Claude activates documentation-writer skill and:
- Reads source/person/classes.edn and properties.edn
- Analyzes structure (2 classes, 36 properties)
- Generates comprehensive README with:
  • Module overview
  • Class descriptions
  • Property listings with metadata
  • 3 practical usage examples
  • Schema.org references
- Saves to source/person/README.md
```

---

### ✅ docs-validator

**Purpose:** Documentation quality validator and completeness checker

**Capabilities:**
- Check documentation coverage (modules, features, guides)
- Validate all internal and external links
- Test code examples for accuracy
- Ensure formatting consistency
- Check for outdated information
- Generate quality reports with scores
- Provide prioritized recommendations

**When to use:**
- "Validate the documentation"
- "Check for broken links"
- "Audit documentation quality"
- "Find missing documentation"
- "Check module coverage"

**Example:**
```
You: "Validate all documentation"

Claude activates docs-validator skill and provides:
- Overall quality score (87/100)
- Coverage metrics (91% modules, 100% features)
- Issues found (2 critical, 6 warnings)
- Specific file locations and fixes
- Prioritized recommendations
- Next action suggestions
```

---

## How Skills Work

### Activation

Skills are activated automatically when you ask relevant questions, or you can invoke them explicitly:

```
# Automatic activation
"Analyze the template" → activates edn-analyzer

# Explicit activation
"Use the edn-analyzer skill to check build/logseq_db_Templates_full.edn"
```

### Skill vs Command

**Commands** (`/command-name`):
- Interactive workflows
- Step-by-step guidance
- Action-oriented
- Modify files/run scripts
- Example: `/new-class`, `/export`, `/release-prep`

**Skills** (activated by context):
- Domain expertise
- Analysis and insights
- Knowledge-oriented
- Provide recommendations
- Example: edn-analyzer, commit-helper, module-health

### Combining Skills and Commands

Skills often work together with commands:

```
1. Create new class: /new-class Recipe
2. Analyze result: "Check module health" (uses module-health skill)
3. Commit changes: "Suggest a commit message" (uses commit-helper skill)
```

## Creating New Skills

To create a new skill:

1. **Identify a domain** where Claude needs specialized knowledge
2. **Create skill directory**: `.claude/skills/skill-name/`
3. **Create SKILL.md** with YAML frontmatter and skill prompt
4. **Add optional files** (reference.md, examples.md, scripts/)
5. **Document in this README**

### Skill Template

Create `.claude/skills/skill-name/SKILL.md`:

```markdown
---
name: skill-name
description: Brief description of what this skill does and when to use it (max 1024 chars). Include both capabilities and activation triggers.
---

# Skill Name

You are a [domain] expert for the Logseq Template Graph project.

## Capabilities
- List of things you can do
- Analysis methods
- Reporting capabilities

## Activation Triggers
- "Keywords that should activate this skill"
- Example questions

## Analysis Process
1. Step-by-step process
2. Tools to use
3. Data to collect

## Output Format
- How to structure reports
- Examples of good output

## Example Interactions
[Detailed examples]

---

**When activated, you become an expert in [domain].**
```

### YAML Frontmatter Requirements

- **name**: Lowercase letters, numbers, and hyphens only (max 64 chars)
- **description**: What the skill does AND when to use it (max 1024 chars)
- **allowed-tools** (optional): Restrict which tools Claude can use

## Skill Ideas for Future

**template-optimizer**
- Suggest property reuse opportunities
- Identify redundant classes
- Optimize file size
- Recommend schema.org alternatives

**migration-assistant**
- Help migrate between template versions
- Generate migration scripts
- Identify breaking changes
- Provide upgrade paths

**schema-advisor**
- Deep Schema.org knowledge
- Suggest standard properties
- Recommend class hierarchies
- Validate against Schema.org spec

**preset-optimizer**
- Suggest preset combinations
- Optimize preset sizes
- Analyze preset usage
- Create preset recommendations

**documentation-generator**
- Auto-generate module docs
- Create usage examples
- Update README files
- Generate API documentation

## Best Practices

### For Skill Creators
1. **Be specific** - Clear scope and capabilities
2. **Provide examples** - Show expected interactions
3. **Define output format** - Consistent, readable reports
4. **Use tools effectively** - Read, Bash, Grep, etc.
5. **Offer actions** - Don't just analyze, suggest fixes

### For Skill Users
1. **Be specific** - "Analyze X" is better than "Check things"
2. **Provide context** - Mention which files to analyze
3. **Ask follow-ups** - Skills can go deeper
4. **Combine skills** - Use multiple for complex tasks
5. **Give feedback** - Help improve skill prompts

## Measuring Success

Good skills should:
- ✅ Activate automatically when relevant
- ✅ Provide accurate analysis
- ✅ Give actionable recommendations
- ✅ Save significant time (30+ min)
- ✅ Improve decision quality
- ✅ Be easy to understand
- ✅ Work consistently

## Maintenance

Skills should be reviewed and updated:
- **Monthly:** Check if still relevant
- **After major changes:** Update for new architecture
- **Based on usage:** Improve based on real usage
- **When new needs arise:** Add new capabilities

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Schema.org](https://schema.org/)
- [EDN Format](https://github.com/edn-format/edn)

---

**Skills transform Claude Code from a helpful assistant into a domain expert for your project.**
