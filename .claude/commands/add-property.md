# Add Schema.org Property

Add a new property to the Logseq template following Schema.org standards.

## Process

1. **Ask the user for:**
   - Property name (e.g., "email", "jobTitle", "isbn", "cookTime")
   - Which class(es) should use this property
   - Purpose/use case

2. **Research Schema.org:**
   - Visit https://schema.org/{PropertyName}
   - Review the property definition
   - Check expected type (Text, URL, Date, Number, Thing, Person, etc.)
   - Determine cardinality (single value or multiple values?)
   - See which Schema.org types typically use this property

3. **Map to Logseq DB types:**
   - Schema.org Text → Logseq `:default`
   - Schema.org URL → Logseq `:url`
   - Schema.org Date → Logseq `:date`
   - Schema.org Number → Logseq `:number`
   - Schema.org Thing/Person/etc → Logseq `:node` (relationship)

4. **Work in Logseq UI:**
   - Open the development graph in Logseq
   - Create/edit the property
   - Set correct type (default, node, date, url, number)
   - Set cardinality (one or many)
   - Add icon (emoji) for visual identification
   - Add clear description
   - Associate with appropriate classes

5. **Export and verify:**
   - Run: `./scripts/export.sh` or `.\scripts\export.ps1`
   - Review diff to verify the property appears correctly
   - Check it's linked to the right classes

6. **Commit:**
   ```bash
   git commit -m "feat: add {propertyName} property to {ClassName}"
   ```

## Example: Adding "cookTime" Property

1. User wants: "Add cookTime property for Recipe class"
2. Research: https://schema.org/cookTime
3. Schema.org details:
   - Expected Type: Duration (text representation like "PT1H30M")
   - Used by: Recipe
   - Cardinality: One value
4. Map to Logseq:
   - Type: `:default` (text)
   - Cardinality: `:db.cardinality/one`
5. Add to Recipe class
6. Export and commit: `feat: add cookTime property to Recipe class`

## Property Type Guide

| Schema.org Type | Logseq Type | Cardinality Notes |
|----------------|-------------|-------------------|
| Text | `:default` | Usually `:one`, sometimes `:many` |
| URL | `:url` | Usually `:one` |
| Date | `:date` | Usually `:one` |
| Number, Integer | `:number` | Usually `:one` |
| Person | `:node` | Can be `:one` or `:many` |
| Organization | `:node` | Can be `:one` or `:many` |
| Thing (any object) | `:node` | Can be `:one` or `:many` |
| Boolean | `:default` + choices | Use choices: ["true", "false"] |

## Cardinality Examples

**One (single value):**
- email (one email address)
- birthDate (one birth date)
- jobTitle (one current job title)

**Many (multiple values):**
- children (multiple Person links)
- skills (multiple skill names)
- knows (multiple Person links)
- alumniOf (multiple Organization links)

## References

- [Schema.org Properties](https://schema.org/docs/properties.html)
- [Technical Reference](../../docs/architecture/technical-reference.md#properties)
- [EDN Format](../../docs/architecture/technical-reference.md#edn-file-format)

## Best Practices

- Always check Schema.org for standard naming and types
- Match Schema.org's expected type to Logseq types
- Consider real-world usage for cardinality
- Add clear, concise descriptions
- Choose appropriate icons
- Test with actual data before committing
