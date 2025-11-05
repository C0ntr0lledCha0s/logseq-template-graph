# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Logseq DB template graph** starter repository that provides structured ontologies for organizing knowledge in Logseq's database format. It contains predefined properties and classes based on Schema.org vocabulary to help users add structure to their Logseq databases.

## File Structure and Purpose

### Core Files

- **logseq_db_Templates.edn** (1,214 lines) - The main template file containing a curated subset of properties and classes. This is the recommended starting point for most users.

- **logseq_db_Templates_full.edn** (6,996 lines) - The comprehensive version with full timestamps (`:block/created-at`, `:block/updated-at`) and additional metadata, representing the complete exported graph ontology.

### EDN File Format

Both EDN files follow the Clojure Extended Data Notation format with this structure:

```clojure
{:properties
 {:user.property/propertyName-UniqueID
  {:db/cardinality :db.cardinality/one  ; or :db.cardinality/many
   :logseq.property/type :default        ; or :node, :date, :url, :number
   :block/title "propertyName"
   :build/property-classes [:user.class/ClassName-UniqueID]
   :build/properties
   {:logseq.property/icon {:id "emoji_name" :type :emoji}
    :logseq.property/description "Description text"}}}

 :classes
 {:user.class/ClassName-UniqueID
  {:block/title "ClassName"
   :build/class-properties [:user.property/prop1 :user.property/prop2]
   :build/class-parent :user.class/ParentClass-ID
   :block/alias #{[:block/uuid #uuid "..."]}
   :build/properties
   {:logseq.property/icon {:id "emoji_name" :type :emoji}
    :logseq.property/description "Description text"}}}

 :logseq.db.sqlite.export/export-type :graph-ontology}
```

## Key Concepts

### Properties

Properties define attributes that can be attached to pages/blocks. Each property has:
- **Cardinality**: `:db.cardinality/one` (single value) or `:db.cardinality/many` (multiple values)
- **Type**: `:default`, `:node` (links to other pages), `:date`, `:url`, `:number`
- **Property Classes**: Which classes this property can be used with
- **Icon and Description**: UI metadata

### Classes

Classes define types of entities (e.g., Person, Organization, Event). Each class has:
- **Class Properties**: List of properties applicable to this class
- **Class Parent**: Inheritance relationship (e.g., Person inherits from Thing)
- **Aliases**: UUID-based references for cross-referencing
- **Build Properties**: Metadata including icons and descriptions

### Schema.org Inspiration

The ontology is heavily inspired by Schema.org vocabulary, including:
- **Thing** - Base class for all entities
- **Person** - People with properties like jobTitle, email, familyName, birthDate
- **Organization** - Companies, schools, NGOs with properties like legalName, employee, member
- **Event** - Events with properties like eventStatus, eventSchedule, attendee
- **Place** - Locations with address and event properties
- **Creative Work** - Books, articles, media with properties like author, isbn

### Naming Convention

- Property IDs: `user.property/propertyName-ShortRandomID`
- Class IDs: `user.class/ClassName-ShortRandomID`
- UUIDs in full version: RFC 4122 format for persistent references

## Common Development Tasks

### Comparing Templates

To understand differences between the two template files:

```bash
# Count properties and classes in each file
grep -c "user.property/" logseq_db_Templates.edn
grep -c "user.class/" logseq_db_Templates.edn
```

### Inspecting Structure

```bash
# Find where classes section starts
grep -n "^ :classes" logseq_db_Templates.edn

# View specific property or class definition
grep -A 20 "user.property/email" logseq_db_Templates.edn
grep -A 30 "user.class/Person" logseq_db_Templates.edn
```

### Working with EDN Files

- EDN files are text-based and can be edited directly with proper Clojure/EDN syntax
- Maintain consistent indentation (2 spaces per level)
- Ensure all brackets `{}`, `[]`, and `#{}` are balanced
- UUIDs should follow RFC 4122 format when present
- Keywords start with `:` and use kebab-case naming

## Important Constraints

1. **Do not modify structural markers**: `:logseq.db.sqlite.export/export-type :graph-ontology` must remain at the end
2. **Preserve unique IDs**: Random suffixes like `-cB8UklzM` ensure property/class uniqueness
3. **UUID references**: When present, UUIDs create persistent cross-references between entities
4. **Cardinality matters**: Changing between `:one` and `:many` affects how Logseq stores values
5. **Property type constraints**: Type changes (e.g., `:default` to `:date`) affect UI and validation

## Schema Relationships

Key parent-child class relationships:
- `Thing` → base for most classes
- `Thing` → `Person`, `Organization`, `Place`
- `Event` → `EventSeries`, `BusinessMeeting`
- Properties like `spouse`, `sibling` are typed as `:node` with cardinality constraints

References to other entities use UUID aliases or property relationships (e.g., `subOrganization` links Organizations).
