## **1.0.0** - 2025-11-09 &emsp;<sub><sup>([4d06db2...2b5a699](https://github.com/C0ntr0lledCha0s/logseq-template-graph/compare/4d06db2996960e9541c0a40c226686592bfe1856...2b5a699fc3c6a0266b596af416e29ba5dea9bcaa))</sup></sub>

**Major Release:** Complete modular workflow system with enterprise-grade CI/CD pipeline, Claude Code integration, and comprehensive documentation.

### 🚀 Major Features

#### Modular Architecture
- **Split monolithic 15K+ line template** into 14 organized source modules ([2b5a699](https://github.com/C0ntr0lledCha0s/logseq-template-graph/commit/2b5a699fc3c6a0266b596af416e29ba5dea9bcaa))
- **6 preset configurations**: full, CRM, research, events, content, student-life
- **Automated build system** using Babashka scripts
- **Interactive preset creator** with live validation
- Reduced git diffs from 500+ lines to 10-20 lines per change

#### Complete CI/CD Pipeline
- **Automated template building** on releases (all variants)
- **Conventional commits validation** with semantic versioning
- **Comprehensive test workflow** for template imports
- **Automated changelog generation** from commit history
- **Git hooks** for pre-push validation and post-commit builds
- **Cross-platform support** (Unix + Windows PowerShell)

#### Claude Code Integration
- **6 specialized skills**: commit-helper, docs-validator, documentation-writer, edn-analyzer, module-health, schema-research
- **9 slash commands** for common workflows
- **Optimized settings** for GitHub operations
- **Comprehensive documentation management** system

#### Developer Experience
- **NPM scripts** for streamlined workflows (`npm run export`, `npm run build:*`)
- **Automatic dependency checking** (Babashka, Logseq CLI)
- **Git hooks** with ASCII-safe output (no emoji corruption in PowerShell)
- **Validation scripts** for modular and complete templates

#### Documentation Overhaul
- **Reorganized into `docs/` folder** with proper structure
- **Comprehensive guides** for users, developers, and contributors
- **Technical reference** and architecture documentation
- **CONTRIBUTING.md** with conventional commits guide
- **Pull request templates** and commit conventions

### 📊 Statistics

- **Template Size:** 15,422 lines (across modular sources)
- **Classes:** 632 (from Schema.org)
- **Properties:** 1,033 (with rich metadata)
- **Source Modules:** 14 (base, person, organization, event, place, creative-work, product, action, intangible, health, misc, common)
- **Preset Variants:** 6 (ranging from 1,500 to 15,422 lines)
- **Files Changed:** 125 (+28,693 insertions, -8,809 deletions)

### 🔧 Technical Improvements

- Migrated from monolithic file to modular structure
- Build process uses Babashka + EDN merging
- All commits follow conventional commits specification
- Automated validation on all pull requests
- Release automation with GitHub Actions

### 📝 Breaking Changes

None - this release maintains backward compatibility with existing template imports.

### 🙏 Acknowledgments

This release represents a complete transformation of the project's development workflow, making it more maintainable, scalable, and contributor-friendly.

---


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
