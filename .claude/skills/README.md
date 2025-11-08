# Claude Code Skills

This directory contains specialized skills that enhance Claude Code's capabilities for the Logseq Template Graph project.

## What Are Skills?

Skills are specialized prompts that give Claude Code deep expertise in specific domains. Unlike commands (which guide workflows), skills provide domain knowledge and analytical capabilities.

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
2. **Create skill file**: `.claude/skills/skill-name.md`
3. **Define capabilities** in the skill prompt
4. **Provide examples** of when to activate
5. **Specify output format** and analysis process
6. **Document in this README**

### Skill Template

```markdown
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
