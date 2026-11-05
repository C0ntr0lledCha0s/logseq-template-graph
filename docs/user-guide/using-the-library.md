# Using the Schema Library

You have imported `schema-library.edn` into a Logseq DB graph (see [Quick Start](../../QUICK_START.md#for-users-import-the-library)). This guide shows how to use the classes and properties it added.

**Contents:**
- [Tag nodes with classes](#tag-nodes-with-classes)
- [Inheritance: more specific classes](#inheritance-more-specific-classes)
- [Property types and values](#property-types-and-values)
- [Example: contacts and clients](#example-contacts-and-clients)
- [Example: projects](#example-projects)
- [Find and query tagged nodes](#find-and-query-tagged-nodes)
- [Updating to a newer release](#updating-to-a-newer-release)
- [Importing only part of the library](#importing-only-part-of-the-library)
- [Troubleshooting](#troubleshooting)

---

## Tag nodes with classes

Each class in the library is a Logseq tag. Tagging a node with it gives the node that class's properties.

- **Tag a block:** type the tag in the block, for example `Jane Smith #Person`.
- **Tag a page:** open the page and add the tag with `p t`.
- **Tags with spaces** need brackets: `#[[Work Item]]`.
- **Several tags on one node** is normal. A client company can be `#Organization` and `#Client`.

After tagging, the node shows the class's properties. Fill in the ones you need; empty ones stay out of the way.

Tag names are the Schema.org names, in Schema.org's capitalisation: `Person`, `Organization`, `Event`, `CreativeWork`, `BlogPosting`. The library's own classes follow the same style: `WorkProfile`, `Client`, `Project`. Property names are Schema.org's camelCase (`birthDate`, `worksFor`); the library's own properties use dashes (`project-status`).

Each class and property has a description, and the Schema.org ones link to their Schema.org definition through their `url` property. Open the tag page (for example `#Person`) to read them and to see every node tagged with it in a table.

## Inheritance: more specific classes

Classes extend other classes, and a tagged node gets the properties of the class **and** of every class above it.

```
Thing          url, sameAs, image, subjectOf
└─ Person      email, telephone, birthDate, knows, ...
   └─ WorkProfile   jobTitle, worksFor, workLocation, colleague, hasOccupation
```

So a node tagged `#WorkProfile` shows work fields **and** all the `Person` and `Thing` fields. You do not need to tag it `#Person` as well.

Use the most specific class that fits:

| You are describing | Tag with |
|---|---|
| A friend or family member | `#Person` |
| A work contact | `#WorkProfile` |
| Someone on your own team | `#Employee` or `#Volunteer` (both extend `TeamMember`, which extends `WorkProfile`) |
| A company | `#Organization`, or `#Business` |
| An article / a blog post | `#Article` / `#BlogPosting` |

The tag page shows what a class extends (its **Extends** property) and which properties it adds.

## Property types and values

Each property has a fixed type. The type decides what you can enter:

| Type | What you enter | Examples |
|---|---|---|
| Text | Any text | `email`, `jobTitle`, `tool` |
| Node | A link to another page or block; some only offer nodes with a given tag | `worksFor` (an Organization), `knows` (a Person), `attendee` |
| Date | A date from the date picker; links to that journal page | `birthDate` |
| Date and time | A date and a time | `startDate`, `endDate` |
| URL | A web address | `url`, `sameAs` |
| Number | A number; sorts numerically | `numberOfEmployees` |
| Choice | One of a fixed list | `project-status`: idea, planned, active, completed, paused, abandoned |

Properties also take either **one value** (`birthDate`, `worksFor`) or **many** (`knows`, `attendee`, `artMedium`). Add another value to a many-valued property instead of a comma-separated list, so each value stays a separate, linkable item.

Node properties are what make the graph connected. `worksFor: [[Acme Ltd]]` puts Jane on the Acme page's linked references, and lets queries walk from people to organisations.

## Example: contacts and clients

1. Create the organisation: a page `Acme Ltd`, tagged `#Organization`. Fill in `legalName`, `email`, `telephone`.
2. Create the person: a page `Jane Smith`, tagged `#WorkProfile`. Set `jobTitle` to `Finance Director` and `worksFor` to `Acme Ltd`.
3. Make Acme a client: add the `#Client` tag to `Acme Ltd`. It adds `relationship-status` (prospect, active, former), `key-relationship-holder` and `operational-relationship-holder`. The holders point to your own people, tagged `#Employee` or `#Volunteer`.
4. Log a meeting: a block `Quarterly review #Event`, with `startDate`, `attendee` = `Jane Smith` and your own people, and `about` = `Acme Ltd`.

Jane's page now lists the meeting in its linked references, and Acme's page lists Jane and the meeting.

## Example: projects

1. Create a page `Website relaunch` tagged `#Project`. Set `project-status` to `active`.
2. Add goals, work items, decisions and obstacles with the project-management classes (`#Goal`, `#[[Work Item]]`, `#Decision`, `#Obstacle`, ...). See the [project-management module](../../source/project-management/README.md) for how they fit together.
3. For ready-made dashboards, import [`views/project-management.edn`](../../views/project-management.edn) with the command palette -> **Import EDN data**. It creates a `PM Views` page with queries for the roadmap, goal health, up-next work and orphaned items.

## Find and query tagged nodes

- **Tag page table:** every tag page lists its tagged nodes in a table. Add columns for any property, sort, filter and group there. This covers most needs.
- **Query builder:** type `/Query` and pick a tag and property filters.
- **Advanced queries:** the library's classes and properties have fixed idents, so queries can match on them and keep working if someone renames a tag in their graph. All work contacts at Acme Ltd:

```clojure
{:query [:find (pull ?p [*])
         :where
         [?p :block/tags ?t]
         [?t :db/ident :custom.class/WorkProfile]
         [?p :schema.property/worksFor ?org]
         [?org :block/title "Acme Ltd"]]}
```

Schema.org terms use `:schema.class/<Name>` and `:schema.property/<name>`; the library's own terms use `:custom.class/<Name>` and `:custom.property/<name>`. The ident is not always the visible title: `Client` is `:custom.class/Customer`, and `project-status` is `:custom.property/projectStatus`. Open a tag or property page to see its ident.

## Updating to a newer release

Download the new `schema-library.edn` and import it the same way. Because idents are fixed, the import **updates** the classes and properties you already have instead of creating duplicates, and adds the new ones. Your own pages, blocks and property values are not touched.

Importing never **removes** anything. When a release drops a property from a class, or removes a class, the [CHANGELOG](../../CHANGELOG.md) lists the manual steps under **Manual steps**. Read the entries between your version and the new one before updating.

## Importing only part of the library

The full library has every class. If you only want the classes for one job (CRM, research, events, content, student life, project management), use the [Ontology Schema Builder plugin](https://github.com/C0ntr0lledCha0s/logseq-ontology-sync-plugin): start from one or more roles, untick what you do not need, and import the result. You can import more later; it uses the same idents, so nothing is duplicated.

## Troubleshooting

| Problem | Fix |
|---|---|
| No library tags appear when typing `#` | The import did not run in this graph. Check that the graph is a **Database** graph, then import again. |
| A tagged node shows no properties | Properties with no value may be hidden. Click the node's properties area, or press `p a` to show all properties. |
| A node property will not accept a page | Some node properties only accept nodes with a given tag. `worksFor` wants an `#Organization`: tag the target page first. |
| A property allows only one value | It is a one-value property by design (for example `birthDate`, `worksFor`). For a person linked to several organisations, put the main employer in `worksFor` and the others in `affiliation`, which takes many. |
| Duplicate tags such as two `Person` tags | One was created by hand before the import. Move its nodes to the library tag, then delete the hand-made one. |

[Back to the documentation portal](../README.md)
