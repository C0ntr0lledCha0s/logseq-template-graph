# Project Management Module

Part of the schema library source. `bb build` merges every module under `source/` into `build/schema-library.edn`.

Classes for running work from strategy down to tasks: Vision, Objectives, Goals, Ideas, Work Items, Decisions, Obstacles and Specs. Used by the `project-management` preset.

## Files

- `classes.edn` - Class definitions (`:classes`)
- `properties.edn` - Property definitions (`:properties`)

Starter query views live outside the library in [`views/project-management.edn`](../../views/project-management.edn).

## Conventions

- Idents are fixed: `:schema.class/*` and `:schema.property/*` for Schema.org terms, `:custom.class/*` and `:custom.property/*` for everything else.
- Every `schema.*` entry carries `:schema.property/url`.
- Edit these files directly, then run `bb test && bb build && bb validate`. Class and property counts are printed by `bb build`.

Schema.org terms used here: `Project` (class, extends both `Container` and Schema.org's `Organization`), `question` and `codeRepository` (properties). Property titles keep the hyphenated names used by Agent Deck (for example `ad-id`, `for-goal`); idents are camelCase (`:custom.property/adId`, `:custom.property/forGoal`). The `branch` title uses `:custom.property/gitBranch` because Schema.org's `branch` means a branch of an organization.

## Tag hierarchy

```
PM Item                      abstract root: ad-id, owner, scope
├── Container                abstract
│   ├── Workspace
│   ├── Portfolio            in-workspace
│   └── Project              in-portfolio, codeRepository, project-type, project-status, default-workflow (also extends Organization)
├── Strategy                 abstract
│   ├── Vision               vision-status, statement
│   ├── Direction            abstract: goal-status, rank, points, success-criteria, parent-direction, progress
│   │   ├── Objective        portfolio-level goal
│   │   └── Goal             project-level goal
│   └── Idea                 for-goal, idea-stage, horizon, reach, impact, effort, confidence, score, delivered-by
├── Governance               abstract
│   ├── Decision             question, decision, rationale, decided-by, supersedes, for-goal
│   ├── Obstacle             obstacle-type, severity, obstacle-status, mitigation, affects
│   └── Spec                 spec-type, spec-status, specifies
└── Work Item                also extends built-in Task (Status, Priority, Deadline)
    │                        for-goal, parent-work, points, phase, branch, pr-url, blocked-by
    ├── Epic
    ├── Feature
    ├── Improvement
    ├── Bug
    └── Subtask
```

Abstract classes (PM Item, Container, Strategy, Direction, Governance) exist to share properties and are never applied directly.

## Traceability

```
Vision (scope) ← Objective (scope = Portfolio) ← Goal (scope = Project, parent-direction)
  ← Idea (for-goal) → delivered-by → Epic › Feature / Task / Bug › Subtask
```

Decisions and Obstacles hang off any level via `for-goal` / `affects`.

## Starter views

Import `views/project-management.edn` into a graph that already has these classes: command palette -> **Import EDN data**. It creates a `PM Views` page:

| View | Query |
|---|---|
| Roadmap | Ideas excluding idea-stage = wont |
| Goal health | Active Goals; blocking Obstacles affecting active Goals, excluding resolved or accepted ones |
| Up next | Work Items (any subtype) with Status Backlog or Todo |
| Orphans | Goals with no parent-direction; Work Items with no lineage to a goal; ready Ideas with no delivered-by |
| Decision log | Decisions not superseded by another Decision |

A Work Item has lineage when it, or its parent-work (up to two levels), has a for-goal or is in an Idea's delivered-by.

The queries filter. Sorting and grouping are table settings saved per view in the app: Roadmap groups by horizon and sorts by score descending; Up next sorts by Priority; Decision log sorts by Created.

## Not enforced by Logseq

These rules are in the property descriptions but must be kept by people or Agent Deck:

- Only one Vision per scope with vision-status = current
- goal-status = achieved is human sign-off only
- horizon is blank at idea-stage impact or wont
- parent-work shape: Epic has no parent, Subtask always has a non-epic parent, max depth 2
- `score` and `progress` are stored numbers, not computed

## Manual step after import

Add a **Halted** choice to the built-in Status property (workflow phase failed, needs a human). A library import can't add choices to built-in properties.
