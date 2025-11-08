# Documentation Index

Complete guide to all documentation in the Logseq Template Graph project.

**📁 All documentation is now organized in the [`docs/`](docs/) folder!**

**Start Here:** [Documentation Portal](docs/README.md) | [README](README.md) | [Quick Start](QUICK_START.md)

---

## 🚀 Quick Navigation

### For Users
- [Project Overview](README.md) - What this project does
- [Quick Start Guide](QUICK_START.md#for-users-import-templates) - Import templates (5 minutes)

### For Developers
- [Developer Setup](QUICK_START.md#for-developers-set-up-development-environment) - Environment setup
- [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) - Automated workflows
- [Technical Reference](docs/architecture/technical-reference.md) - Deep dive

### For Large Templates (15K+ lines)
- [Modular Quickstart](docs/modular/quickstart.md) - 5-minute guide
- [Modularization Strategy](docs/modular/strategy.md) - Complete plan

---

## 📖 All Documentation

### Root Level (Quick Access)

| File | Audience | Description |
|------|----------|-------------|
| [README.md](README.md) | Everyone | Project overview, features, quick start |
| [QUICK_START.md](QUICK_START.md) | Users & Developers | 5-minute installation and setup guide |
| **[docs/README.md](docs/README.md)** | **Everyone** | **📚 Documentation Portal** |

### User Guides (`docs/user-guide/`)

| File | Description |
|------|-------------|
| [ui-export-guide.md](docs/user-guide/ui-export-guide.md) | Export EDN via UI, keyboard shortcuts, partial export strategies |

### Developer Guides (`docs/developer-guide/`)

| File | Description |
|------|-------------|
| [ci-cd-pipeline.md](docs/developer-guide/ci-cd-pipeline.md) | Complete CI/CD workflow, automation, git integration |
| [conventional-commits-guide.md](docs/developer-guide/conventional-commits-guide.md) | Automated changelog generation and semantic versioning |
| [conventional-commits-integration.md](docs/developer-guide/conventional-commits-integration.md) | Integration details, setup, and troubleshooting |
| [modularization-review.md](docs/developer-guide/modularization-review.md) | GitHub Actions implementation and testing plans |
| [implementation-summary.md](docs/developer-guide/implementation-summary.md) | Overview of what was built |

### Modular Development (`docs/modular/`)

| File | Description |
|------|-------------|
| [quickstart.md](docs/modular/quickstart.md) | 5-minute modular workflow guide |
| [strategy.md](docs/modular/strategy.md) | Complete modularization plan with split/build scripts |
| [architecture-report.md](docs/modular/architecture-report.md) | Complete modular architecture status and roadmap |

### Architecture (`docs/architecture/`)

| File | Description |
|------|-------------|
| [technical-reference.md](docs/architecture/technical-reference.md) | EDN format, class hierarchy, Schema.org mapping, best practices |

### Research (`docs/research/`)

| File | Description |
|------|-------------|
| [comprehensive-analysis.md](docs/research/comprehensive-analysis.md) | Deep dive: Logseq DB, Tana, Schema.org (10 sections, ultra-comprehensive) |

---

## 🎯 Find Documentation By Task

### I want to...

| Task | Documentation |
|------|---------------|
| **Use the templates** | [Quick Start - Users](QUICK_START.md#for-users-import-templates) |
| **Install Logseq DB** | [Quick Start - Step 0](QUICK_START.md#step-0-install-logseq-database-version) |
| **Set up development** | [Quick Start - Developers](QUICK_START.md#for-developers-set-up-development-environment) |
| **Export templates (CLI)** | [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md#manual-development-workflow) |
| **Export templates (UI)** | [UI Export Guide](docs/user-guide/ui-export-guide.md) |
| **Work with huge templates** | [Modular Quickstart](docs/modular/quickstart.md) |
| **Understand architecture** | [Technical Reference](docs/architecture/technical-reference.md) |
| **Learn about Logseq DB/Tana** | [Comprehensive Analysis](docs/research/comprehensive-analysis.md) |
| **Add new classes** | [CI/CD Pipeline](docs/developer-guide/ci-cd-pipeline.md) + [Technical Reference](docs/architecture/technical-reference.md) |

---

## 📊 Documentation Stats

- **Total Documents**: 14 comprehensive guides
- **Total Lines**: 6,000+ lines of documentation
- **Organization**: Categorized in `docs/` folder
- **Last Major Update**: November 2025 (modular workflow and conventional commits added)

---

## 🗺️ Recommended Reading Order

### Path 1: New User (5 minutes)
```
README → Quick Start → Start using templates!
```

### Path 2: New Developer (30 minutes)
```
README → Quick Start (Dev) → CI/CD Pipeline → Technical Reference
```

### Path 3: Modular Development (20 minutes)
```
CI/CD Pipeline (Modular section) → Modular Quickstart → Modularization Strategy
```

### Path 4: Deep Understanding (2+ hours)
```
Comprehensive Analysis → Technical Reference → Modularization Strategy → CI/CD Pipeline
```

---

## 📁 Complete File Structure

```
logseq-template-graph/
├── README.md                              ← Start here
├── QUICK_START.md                         ← 5-minute guide
├── DOCS_INDEX.md                          ← This file
│
└── docs/                                  ← 📚 All documentation
    ├── README.md                          ← Documentation portal
    │
    ├── user-guide/                        ← For template users
    │   └── ui-export-guide.md             ← UI export & keyboard shortcuts
    │
    ├── developer-guide/                   ← For contributors
    │   ├── ci-cd-pipeline.md              ← Workflows & automation
    │   ├── conventional-commits-guide.md  ← Commit standards
    │   ├── conventional-commits-integration.md ← Setup & troubleshooting
    │   ├── modularization-review.md       ← GitHub Actions implementation
    │   └── implementation-summary.md      ← What was built
    │
    ├── modular/                           ← For large templates
    │   ├── quickstart.md                  ← Quick modular guide
    │   ├── strategy.md                    ← Complete plan
    │   └── architecture-report.md         ← Status & roadmap
    │
    ├── architecture/                      ← Technical deep-dives
    │   └── technical-reference.md         ← EDN format, classes
    │
    └── research/                          ← Background analysis
        └── comprehensive-analysis.md      ← Logseq/Tana/Schema.org
```

---

## 🔗 External Resources

### Logseq
- [Logseq Official Docs](https://docs.logseq.com)
- [Logseq Database Guide](https://github.com/logseq/docs/blob/master/db-version.md)
- [Logseq Forums](https://discuss.logseq.com)
- [Logseq CLI on npm](https://www.npmjs.com/package/@logseq/cli)

### Schema.org
- [Schema.org Homepage](https://schema.org)
- [Person Type](https://schema.org/Person)
- [Organization Type](https://schema.org/Organization)
- [Event Type](https://schema.org/Event)

### Tana
- [Tana Supertags Documentation](https://tana.inc/docs/supertags)

### Tools
- [EDN Format Specification](https://github.com/edn-format/edn)
- [Babashka](https://babashka.org/) - For modular workflow

---

## 🤝 Contributing to Documentation

When updating documentation:

1. **Update DOCS_INDEX.md** (this file) if adding new docs
2. **Update docs/README.md** (documentation portal)
3. **Cross-link related sections**
4. **Keep navigation consistent**
5. **Test all links before committing**

---

**💡 Tip:** Bookmark the [Documentation Portal](docs/README.md) for organized navigation!

**Last Updated:** November 2025

[Back to README](README.md) | [Documentation Portal](docs/README.md)
