# Changelog

All notable changes to the Logseq Template Graph project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Modular template structure with 11 Schema.org categories
- 5 preset variants: full, crm, research, content, events
- GitHub Actions CI/CD pipeline (build, validate, release)
- Automated template building on source changes
- Automated EDN validation on pull requests
- Automated release creation with all variants

### Changed
- Migrated from monolithic 15,422-line file to modular structure
- Build process now uses Babashka + EDN merging
- Git diffs reduced from 500+ lines to 10-20 lines per change

### Technical Details
- **Total Lines:** 15,422 (distributed across modules)
- **Properties:** 1,033 (organized by Schema.org categories)
- **Classes:** 632 (hierarchical structure)
- **Modules:** 11 (base, person, organization, event, place, creative-work, product, action, intangible, misc, common)
- **Presets:** 5 (full, crm, research, content, events)

---

## [0.2.0] - 2025-11-06

### Added
- Comprehensive documentation in `docs/` folder
- CI/CD pipeline guide
- Modular development strategy
- Technical reference documentation
- Research report on Logseq/Tana/Schema.org

### Changed
- Restructured documentation for better organization
- Updated README with clearer project overview

### Fixed
- Export script improvements
- Validation script enhancements

---

## [0.1.0] - 2025-03-31

### Added
- Initial template with 632 classes from Schema.org
- 1,033 properties with rich metadata
- Core classes: Thing, Person, Organization, Event, Place, CreativeWork
- Export scripts for Logseq CLI
- Validation and analysis scripts

### Documentation
- README with project overview
- QUICK_START guide
- Basic technical documentation

---

## Template Variants (Unreleased)

### Full Template
- **Size:** ~15,422 lines
- **Classes:** 632
- **Properties:** 1,033
- **Use case:** Complete Schema.org vocabulary

### CRM Template
- **Size:** ~2,000 lines (estimated)
- **Classes:** Person, Organization, base
- **Properties:** ~200
- **Use case:** Customer relationship management

### Research Template
- **Size:** ~3,000 lines (estimated)
- **Classes:** Person, CreativeWork, Event, base
- **Properties:** ~300
- **Use case:** Academic research and note-taking

### Content Creator Template
- **Size:** ~2,500 lines (estimated)
- **Classes:** CreativeWork, Person, base
- **Properties:** ~250
- **Use case:** Bloggers, writers, content creators

### Events Template
- **Size:** ~1,500 lines (estimated)
- **Classes:** Event, Person, Place, Organization, base
- **Properties:** ~150
- **Use case:** Event management and calendar

---

## Release Process

1. Update this CHANGELOG.md with version changes
2. Commit changes: `git commit -m "chore: release vX.Y.Z"`
3. Tag release: `git tag vX.Y.Z`
4. Push with tags: `git push --tags`
5. GitHub Actions automatically creates release with all variants

---

## Links

- [Repository](https://github.com/C0ntr0lledCha0s/logseq-template-graph)
- [Releases](https://github.com/C0ntr0lledCha0s/logseq-template-graph/releases)
- [Documentation](docs/README.md)
- [Issue Tracker](https://github.com/C0ntr0lledCha0s/logseq-template-graph/issues)
