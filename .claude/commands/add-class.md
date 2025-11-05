# Add Schema.org Class

Add a new class to the Logseq template following Schema.org standards.

## Process

1. **Ask the user for:**
   - Class name (e.g., "Recipe", "Book", "Product", "MedicalCondition")
   - Purpose/use case for this class

2. **Research Schema.org:**
   - Visit https://schema.org/{ClassName}
   - Review the class definition
   - Identify parent class (usually Thing or a subclass)
   - List relevant properties from Schema.org
   - Check property types and cardinality

3. **Work in Logseq UI:**
   - Open the development graph in Logseq
   - Create a new page with the class name
   - Add the class as a type/class in Logseq DB
   - Add relevant properties from Schema.org:
     - Set appropriate types (Text, Node, Date, URL, Number)
     - Set cardinality (one/many)
     - Add icons (emojis) for visual identification
     - Add descriptions
   - Set parent class for inheritance

4. **Export the changes:**
   - Run export command: `./scripts/export.sh` or `.\scripts\export.ps1`
   - Review the diff to verify the new class appears correctly

5. **Commit:**
   ```bash
   git add logseq_db_Templates*.edn
   git commit -m "feat: add {ClassName} class with Schema.org properties"
   ```

## Example: Adding Recipe Class

1. User wants: "Add Recipe class for cooking recipes"
2. Research: https://schema.org/Recipe
3. Identify properties:
   - name (Text, one)
   - description (Text, one)
   - author (Node → Person/Organization, many)
   - recipeIngredient (Text, many)
   - recipeInstructions (Text, one)
   - cookTime (Text, one)
   - prepTime (Text, one)
   - recipeYield (Text, one)
   - nutrition (Node → NutritionInformation, one)
4. Parent: CreativeWork (which inherits from Thing)
5. Export and commit

## References

- [Schema.org Homepage](https://schema.org)
- [Technical Reference](../../docs/architecture/technical-reference.md)
- [CI/CD Pipeline](../../docs/developer-guide/ci-cd-pipeline.md)

## Best Practices

- Always check Schema.org first for standard naming
- Use Schema.org's property types as guidance
- Add clear descriptions for non-obvious properties
- Choose appropriate icons/emojis
- Test import in a fresh graph before committing
- Follow semantic commit messages
