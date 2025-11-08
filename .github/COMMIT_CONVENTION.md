# Commit Message Convention - Quick Reference

## Format

```
<type>(<scope>): <description>
```

## Types

| Type | Use For | Example |
|------|---------|---------|
| `feat` | New features | `feat(classes): add Recipe class` |
| `fix` | Bug fixes | `fix(templates): correct cardinality` |
| `docs` | Documentation | `docs: update installation guide` |
| `style` | Formatting | `style: fix indentation` |
| `refactor` | Code restructuring | `refactor(modular): split modules` |
| `perf` | Performance | `perf(scripts): optimize parsing` |
| `test` | Tests | `test: add Recipe validation tests` |
| `build` | Build/dependencies | `build(ci): update workflow` |
| `ops` | Infrastructure | `ops: update deployment config` |
| `chore` | Miscellaneous | `chore: update .gitignore` |

## Scopes

- `templates` - .edn files
- `classes` - Schema.org classes
- `properties` - Schema.org properties
- `ci` - CI/CD pipeline
- `scripts` - Build/export scripts
- `docs` - Documentation
- `release` - Release process
- `modular` - Modular architecture
- `workflow` - Dev workflow

## Examples

```bash
# Simple feature
git commit -m "feat(classes): add Recipe class"

# Bug fix
git commit -m "fix(properties): correct spouse cardinality"

# Documentation
git commit -m "docs: update README"

# Breaking change
git commit -m "feat(classes)!: remove Customer class

BREAKING CHANGE: Use Person with customerRole instead"
```

## Setup

```bash
npm install
npm run setup
```

## More Info

See [CONTRIBUTING.md](../CONTRIBUTING.md) for complete guidelines.
