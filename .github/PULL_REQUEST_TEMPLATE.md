# Pull Request

## Summary

Brief description of what this PR does.

## Type of Change

- [ ] `feat` - New feature or enhancement
- [ ] `fix` - Bug fix
- [ ] `docs` - Documentation update
- [ ] `style` - Code formatting (no logic changes)
- [ ] `refactor` - Code restructuring
- [ ] `perf` - Performance improvement
- [ ] `test` - Test additions or corrections
- [ ] `build` - Build system or CI/CD changes
- [ ] `ops` - Infrastructure or deployment
- [ ] `chore` - Miscellaneous changes

## Scope

Which area does this affect?

- [ ] `source` - source/ EDN files
- [ ] `classes` - Schema.org class definitions
- [ ] `properties` - Schema.org property definitions
- [ ] `ci` - CI/CD pipeline
- [ ] `scripts` - Build/validation scripts
- [ ] `docs` - Documentation
- [ ] `release` - Release process
- [ ] `presets` - Role presets
- [ ] `workflow` - Development workflow
- [ ] Other: _______________

## Changes Made

Detailed list of changes:

- Added...
- Updated...
- Fixed...
- Removed...

## Testing

How was this tested?

- [ ] Imported `schema-library.edn` into a fresh Logseq graph (or ran `bb check-import`)
- [ ] Verified properties appear correctly in UI
- [ ] Tested class inheritance
- [ ] Ran `bb test && bb build && bb validate`
- [ ] Other: _______________

## Screenshots (if applicable)

Add screenshots showing:
- Logseq UI with new classes/properties
- Before/after comparisons
- Any visual changes

## Related Issues

Closes #___
Relates to #___
Fixes #___

## Breaking Changes

- [ ] This PR includes breaking changes

If yes, describe the breaking changes and migration path:

```
BREAKING CHANGE: Description here

Migration steps:
1. ...
2. ...
```

## Commit Message Compliance

- [ ] All commits follow [Conventional Commits](https://www.conventionalcommits.org/) format
- [ ] Commit messages are clear and descriptive
- [ ] Each commit is focused on a single change

**Example commit messages:**
```
feat(classes): add Recipe class with cookTime property
fix(properties): correct spouse cardinality
docs: update installation guide
```

See [CONTRIBUTING.md](../CONTRIBUTING.md#commit-message-guidelines) for details.

## Checklist

- [ ] I have read [CONTRIBUTING.md](../CONTRIBUTING.md)
- [ ] My commits follow the conventional commits format
- [ ] I have updated documentation (if applicable)
- [ ] I have tested the library in Logseq
- [ ] I have run `bb test && bb build && bb validate`
- [ ] I have added/updated tests (if applicable)
- [ ] CHANGELOG.md updated (if applicable)

## Additional Notes

Any additional information, context, or explanations:

---

**Thank you for contributing!**
