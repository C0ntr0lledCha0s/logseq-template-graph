# Custom Claude Code Commands

This folder contains custom slash commands for Claude Code in this project.

## How Custom Commands Work

Any markdown file you place in this folder becomes a slash command:
- `fix-bug.md` → `/fix-bug` command
- `add-class.md` → `/add-class` command
- `build-library.md` → `/build-library` command

## Command File Format

Each command file should contain the prompt/instructions you want Claude to execute:

```markdown
# Command Name

Instructions for what Claude should do when this command is invoked.

Can include:
- Step-by-step instructions
- Code examples
- Best practices
- Links to documentation
```

## Example Commands for This Project

### `/add-class` - Add a new Schema.org class
Create a file: `add-class.md`

```markdown
# Add Schema.org Class

Add a new class to the schema library following these steps:

1. Ask the user for the class name (e.g., "Recipe", "Book", "Product")
2. Research the Schema.org definition at https://schema.org/{ClassName}
3. Identify relevant properties from Schema.org
4. Add the class definition to the fitting source/<module>/classes.edn (fixed `:schema.class/*` ident, or `:custom.class/*` if Schema.org has no such class)
5. Run: bb test && bb build && bb validate
6. Commit with message: "feat: add {ClassName} class"

Follow the documentation at docs/architecture/technical-reference.md
```

### `/test-workflow` - Run the full check
Create a file: `test-workflow.md`

```markdown
# Test Workflow

Run the complete check and report the result:

1. Run: bb test && bb build && bb validate
2. Report the class and property counts printed by bb build
3. If anything fails, show the error and the source/ file it points at
```

## Adding Commands

1. Create a new `.md` file in this folder
2. Write the instructions/prompt
3. Save the file
4. The command becomes available in Claude Code immediately
5. Commit the command file to share with your team

## Best Practices

- **Keep commands focused** - One clear task per command
- **Include context** - Reference relevant documentation
- **Be specific** - Provide exact steps and examples
- **Test commands** - Verify they work before committing
- **Document parameters** - If the command needs user input, specify it clearly

## Resources

- [Claude Code Slash Commands Documentation](https://docs.claude.com/en/docs/claude-code/slash-commands)
- [Project Documentation](../../docs/README.md)
- [CLAUDE.md](../../CLAUDE.md) - Main project configuration
