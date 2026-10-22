# Schema Research - Examples

This file contains example research workflows for investigating Schema.org classes and properties.

## Example 1: Research New Class (Recipe)

**User Request:**
> "Research the Recipe class from Schema.org before I add it"

**Research Process:**

### Step 1: Fetch Schema.org Definition
```
WebFetch: https://schema.org/Recipe
Result: Recipe is a subtype of CreativeWork

Description: A recipe. For dietary restrictions covered by the recipe, a few common restrictions are enumerated via suitableForDiet. The keywords property can also be used to add more detail.
```

### Step 2: Analyze Hierarchy
```
Thing → CreativeWork → Recipe

Inherited from Thing (8 properties):
- name, description, url, identifier, image, sameAs, alternateName, disambiguatingDescription

Inherited from CreativeWork (12 properties):
- author, dateCreated, dateModified, genre, headline, keywords, license, publisher, version, etc.

Direct Recipe Properties (15):
- recipeIngredient, recipeInstructions, cookTime, prepTime, totalTime
- recipeYield, recipeCuisine, recipeCategory, nutrition, suitableForDiet
- cookingMethod, ingredients (deprecated, use recipeIngredient)
```

###Step 3: Check Template Status
```bash
# Check if Recipe exists
grep -r ":schema.class/Recipe" source/
# Result: Not found

# Check if CreativeWork exists
grep -r "CreativeWork" source/
# Result: Found in source/creative-work/classes.edn

# Check creative-work module
ls source/creative-work/
# Result: classes.edn, properties.edn, README.md
```

### Step 4: Generate Report

```
📚 Schema.org Class Research: Recipe
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Definition:
A recipe with cooking instructions, ingredients, and timing.
Used for food recipes, cooking instructions, and dietary information.

Hierarchy:
Thing → CreativeWork → Recipe

Properties (35 total):

From Thing (8 inherited):
  ✅ name (Text) - Already in common/
  ✅ description (Text) - Already in common/
  ✅ url (URL) - Already in common/
  ✅ image (URL) - Already in common/
  + 4 more standard Thing properties

From CreativeWork (12 inherited):
  ✅ author (Person|Organization) - Already in creative-work/
  ✅ dateCreated (Date) - Already in creative-work/
  ✅ keywords (Text) - Already in creative-work/
  + 9 more CreativeWork properties

Direct Recipe Properties (15):
  ➕ recipeIngredient (Text, :many) - List of ingredients
  ➕ recipeInstructions (Text) - Cooking instructions
  ➕ cookTime (Duration) - Active cooking time
  ➕ prepTime (Duration) - Preparation time
  ➕ totalTime (Duration) - Total time needed
  ➕ recipeYield (Text) - Servings or quantity
  ➕ recipeCuisine (Text) - Cuisine type (Italian, Chinese, etc.)
  ➕ recipeCategory (Text) - Course category (appetizer, dessert, etc.)
  ➕ nutrition (NutritionInformation) - Nutritional info
  ➕ suitableForDiet (RestrictedDiet) - Dietary restrictions
  ➕ cookingMethod (Text) - Cooking technique
  + 4 more optional properties

Template Status:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
❌ Recipe class - Not in template
✅ Parent class exists: CreativeWork (in creative-work/)
✅ Module exists: creative-work/
✅ Common properties available: name, description, url, image

Recommendation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Add to: creative-work/ module
Parent: :schema.class/CreativeWork

Required Properties (Add to creative-work/properties.edn):
➕ recipeIngredient (:default, :many) - Core ingredient list
➕ recipeInstructions (:default, :one) - Step-by-step instructions
➕ cookTime (:default, :one) - Cooking duration
➕ prepTime (:default, :one) - Prep duration
➕ recipeYield (:default, :one) - Number of servings

Optional Properties (High Value):
➕ recipeCuisine (:default, :one) - Cuisine type
➕ recipeCategory (:default, :one) - Course type
➕ totalTime (:default, :one) - Total time
➕ cookingMethod (:default, :one) - Technique used
➕ suitableForDiet (:default, :many) - Dietary restrictions

Related Classes to Consider:
- NutritionInformation - Nutrition facts
- HowToStep - Individual instruction steps
- RestrictedDiet - Dietary restriction types

Example Use Cases:
1. Personal recipe collection in Logseq
2. Meal planning with dietary restrictions
3. Cookbook organization
4. Food blog content management

Next Steps:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Add Recipe class to source/creative-work/classes.edn:
   ```clojure
   :schema.class/Recipe
   {:block/title "Recipe"
    :build/class-extends [:schema.class/CreativeWork]
    :build/class-properties [:schema.property/recipeIngredient ...]
    :build/properties
    {:logseq.property/icon {:id "🍳" :type :emoji}
     :logseq.property/description "A recipe with cooking instructions"}}
   ```

2. Add 5-10 properties to source/creative-work/properties.edn

3. Update source/creative-work/README.md with Recipe usage examples

4. Build and test:
   ```bash
   bb test && bb build && bb validate
   # Import into Logseq test graph
   # Create test Recipe page
   # Verify properties appear
   ```

5. Commit:
   ```bash
   git commit -m "feat(classes): add Recipe class to creative-work module

   - Added Recipe class with cooking-specific properties
   - Properties: recipeIngredient, cookTime, prepTime, recipeInstructions, recipeYield
   - Parent class: CreativeWork
   - Use cases: recipe collection, meal planning, cookbook management"
   ```
```

---

## Example 2: Find Missing Properties for Existing Class

**User Request:**
> "What Schema.org properties are we missing for the Person class?"

**Research Process:**

### Step 1: Fetch Schema.org Person Properties
```
WebFetch: https://schema.org/Person

All Person Properties (50+ from Schema.org):
- address, affiliation, alumniOf, award, birthDate, birthPlace
- children, colleague, contactPoint, deathDate, deathPlace
- email, familyName, faxNumber, follows, gender, givenName
- hasOccupation, hasOfferCatalog, height, homeLocation
- honorificPrefix, honorificSuffix, jobTitle, knows
- makesOffer, memberOf, nationality, netWorth, owns
- parent, performerIn, publishingPrinciples, relatedTo
- seeks, sibling, sponsor, spouse, taxID, telephone
- vatID, weight, workLocation, worksFor
+ more...
```

### Step 2: Check Template's Person Class
```bash
grep -A 20 ":schema.class/Person" source/person/classes.edn
# Extract current properties list
```

### Step 3: Compare and Generate Report

```
🔍 Missing Properties Analysis: Person Class
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Person Properties in Template (28):
✅ jobTitle, email, telephone, birthDate, spouse
✅ worksFor, colleague, knows, parent, children
✅ sibling, address, nationality, gender
+ 14 more...

Missing from Schema.org (22 high-value properties):

High Priority (Commonly Used):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. givenName (Text, :one)
   - First/given name
   - Use: Separate from full name
   - Add to: person/properties.edn

2. familyName (Text, :one)
   - Last/family name
   - Use: Surname field
   - Add to: person/properties.edn

3. honorificPrefix (Text, :one)
   - Title (Dr., Prof., Mr., Ms.)
   - Use: Professional titles
   - Add to: person/properties.edn

4. honorificSuffix (Text, :one)
   - Suffix (Jr., Sr., PhD, MD)
   - Use: Academic/professional credentials
   - Add to: person/properties.edn

5. alumniOf (Organization, :many)
   - Educational institutions attended
   - Use: Education history
   - Add to: person/properties.edn

6. memberOf (Organization, :many)
   - Organization memberships
   - Use: Professional associations, clubs
   - Add to: person/properties.edn

Medium Priority:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

7. birthPlace (Place, :one)
   - Location of birth
   - Use: Biographical info

8. homeLocation (Place, :one)
   - Current residence
   - Use: Contact/location info

9. workLocation (Place, :one)
   - Work address
   - Use: Professional info

10. contactPoint (ContactPoint, :many)
    - Structured contact info
    - Use: Multiple contact methods

11. award (Text, :many)
    - Awards received
    - Use: Achievements tracking

12. follows (Person, :many)
    - People followed/connections
    - Use: Social network

Low Priority (Specialized):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

13. netWorth (MonetaryAmount)
14. height (Distance)
15. weight (Mass)
16. vatID (Text)
17. taxID (Text)
18. faxNumber (Text)
19. owns (Product)
20. seeks (Demand)

Recommendation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase 1 (Add Now):
Add 6 high-priority properties:
- givenName, familyName (name components)
- honorificPrefix, honorificSuffix (titles)
- alumniOf, memberOf (affiliations)

Estimated effort: 30 minutes
Impact: Significant - enables proper name handling and affiliations

Phase 2 (Add Later):
Add 6 medium-priority properties for location and contact tracking

Phase 3 (Consider):
Specialized properties based on user feedback

Next Steps:
1. Add 6 properties to source/person/properties.edn
2. Update Person class with new properties
3. Update person/README.md with examples
4. Test in Logseq
```

---

## Example 3: Validate Property Type Mapping

**User Request:**
> "Should 'birthDate' be :date or :default type in Logseq?"

**Analysis:**

```
🔍 Property Type Validation: birthDate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Schema.org Definition:
- Property: birthDate
- Expected Type: Date
- Description: Date of birth
- Format: YYYY-MM-DD or DateTime

Logseq Type Options:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Option 1: :date (RECOMMENDED ✅)
- Logseq renders date picker
- Formatted display in UI
- Can query/filter by date
- Supports date calculations
- Better UX for users

Option 2: :default (NOT recommended ❌)
- Plain text entry
- No date picker
- No date formatting
- No date queries
- Manual validation needed

Recommendation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Use: :date
Cardinality: :db.cardinality/one (single birth date)

Definition:
```clojure
:schema.property/birthDate
{:db/cardinality :db.cardinality/one
 :logseq.property/type :date
 :block/title "birthDate"
 :build/property-classes [:schema.class/Person]
 :build/properties
 {:logseq.property/icon {:id "🎂" :type :emoji}
  :logseq.property/description "Date of birth"}}
```

Benefits of :date:
1. Native date picker in Logseq UI
2. Standardized date format
3. Can query "show all birthdays this month"
4. Can calculate age automatically
5. Better data quality (prevents "1985" vs "Jan 1985" inconsistencies)

Example Queries Enabled:
```clojure
;; Find birthdays this month
(query (and (page-property birthDate)
            (between birthDate [[this-month]])))

;; Sort people by age
(query (sort-by birthDate :desc))
```
```

---

## Example 4: Research Property for Multiple Classes

**User Request:**
> "Research the 'location' property - which of our classes should use it?"

**Analysis:**

```
🔍 Property Research: location
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Schema.org Definition:
- Property: location
- Expected Type: Place, PostalAddress, Text, VirtualLocation
- Description: The location of the event, organization, or action
- Cardinality: Can be multiple

Used By (Schema.org):
- Action - Location where action takes place
- Event - Event venue/location
- Organization - Organization's physical location
- InteractionCounter - Location of interaction

Current Template Status:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Check existing classes:
✅ Event - EXISTS in source/event/classes.edn
✅ Organization - EXISTS in source/organization/classes.edn
✅ Action - EXISTS in source/action/classes.edn
❌ InteractionCounter - Not in template

Check if location property exists:
grep -r "location" source/*/properties.edn
Result: ❌ Not found - Need to add

Recommendation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Add location property to: common/properties.edn
(Shared by multiple classes)

Type: :node (links to Place pages)
Cardinality: :db.cardinality/many (events can have multiple locations)

Assign to Classes:
1. Event - Primary use case (event venues)
2. Organization - Office/branch locations
3. Action - Where action occurred

Property Definition:
```clojure
:schema.property/location
{:db/cardinality :db.cardinality/many
 :logseq.property/type :node
 :block/title "location"
 :build/property-classes
 [:schema.class/Event
  :schema.class/Organization
  :schema.class/Action]
 :build/properties
 {:logseq.property/icon {:id "📍" :type :emoji}
  :logseq.property/description "Physical or virtual location"}}
```

Use Cases:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Event Examples:
- Conference → [[Convention Center]]
- Meeting → [[Office - Room 304]]
- Webinar → [[Virtual - Zoom]]

Organization Examples:
- Company → [[Headquarters]], [[Branch Office]]
- University → [[Main Campus]], [[Satellite Campus]]

Action Examples:
- CreateAction → [[Workshop Studio]]
- TradeAction → [[Marketplace]]

Implementation Steps:
1. Add property to source/common/properties.edn
2. Update Event, Organization, Action classes
3. Create example Place pages for testing
4. Document in README files
5. Test location linking in Logseq
```

---

## Example 5: Research Class Hierarchy (Complete Chain)

**User Request:**
> "What's the complete hierarchy for MedicalCondition and what properties does it inherit?"

**Analysis:**

```
🌳 Complete Class Hierarchy: MedicalCondition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Hierarchy Chain (4 levels):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Thing (Root)
  ↓
MedicalEntity
  ↓
MedicalCondition
  ↓
  ├─ InfectiousDisease
  └─ 12 other child classes

Property Inheritance:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Level 1: Thing (8 properties)
  - name (Text)
  - description (Text)
  - url (URL)
  - identifier (Text)
  - image (URL)
  - sameAs (URL)
  - alternateName (Text)
  - disambiguatingDescription (Text)

Level 2: MedicalEntity (5 properties)
  - code (MedicalCode) - Medical coding (ICD-10, etc.)
  - guideline (MedicalGuideline) - Treatment guidelines
  - legalStatus (MedicalEnumeration) - Legal status
  - medicineSystem (MedicineSystem) - Medical system
  - recognizingAuthority (Organization) - Authority

Level 3: MedicalCondition (14 direct properties)
  - associatedAnatomy (AnatomicalStructure) - Body part affected
  - cause (MedicalCause) - Cause of condition
  - differentialDiagnosis (DDxElement) - Differential diagnosis
  - drug (Drug) - Drugs used for treatment
  - epidemiology (Text) - Epidemiological data
  - expectedPrognosis (Text) - Expected outcome
  - naturalProgression (Text) - Natural course
  - pathophysiology (Text) - Disease mechanism
  - possibleComplication (Text) - Possible complications
  - possibleTreatment (MedicalTherapy) - Treatment options
  - primaryPrevention (MedicalTherapy) - Prevention methods
  - riskFactor (MedicalRiskFactor) - Risk factors
  - secondaryPrevention (MedicalTherapy) - Secondary prevention
  - signOrSymptom (MedicalSignOrSymptom) - Signs/symptoms
  - stage (MedicalConditionStage) - Disease stage
  - status (MedicalStatus) - Current status
  - typicalTest (MedicalTest) - Diagnostic tests

Total Inherited Properties: 27
Direct Properties: 14
Grand Total: 41 properties

Child Classes:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- InfectiousDisease
- MedicalSignOrSymptom
- MentalDisease (Note: Not in template)
- ... 10 more

Template Status:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❌ MedicalCondition - Not in template
❌ MedicalEntity - Not in template
❌ Medical domain - No dedicated module

Current State:
- A few medical classes scattered in misc/ module
- No cohesive medical domain structure
- Missing medical-specific properties

Recommendation:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Option A: Add to New medical/ Module (RECOMMENDED)
✅ Create source/medical/ module
✅ Add MedicalEntity as base class
✅ Add MedicalCondition and key child classes
✅ Add medical-specific properties
✅ Move existing medical classes from misc/

Structure:
```
source/medical/
├── classes.edn (MedicalEntity, MedicalCondition, Drug, etc.)
├── properties.edn (medical-specific properties)
└── README.md
```

Option B: Add to misc/ Module
⚠️  Not recommended - medical domain is substantial
⚠️  Would bloat misc/ further

Implementation Plan:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase 1: Create medical/ module
- Add MedicalEntity (base class)
- Add MedicalCondition
- Add 5-8 core medical properties

Phase 2: Add related classes
- Drug
- MedicalProcedure
- MedicalTest
- Physician/Hospital (move from misc/)

Phase 3: Expand properties
- Add full medical property set
- Add medical code systems

Effort Estimate: 3-4 hours
Impact: Enables medical/health tracking use cases

Use Cases Enabled:
- Personal health tracking
- Medical research organization
- Healthcare professional notes
- Symptom tracking
- Treatment planning
```

---

## Quick Command Reference

| Research Goal | Example Command |
|---------------|-----------------|
| New class | "Research Recipe class from Schema.org" |
| Missing properties | "What properties are missing for Person?" |
| Property type | "Should birthDate be :date or :default?" |
| Property usage | "Which classes should use 'location' property?" |
| Full hierarchy | "Show complete hierarchy for MedicalCondition" |
| Module placement | "Where should I add the Event class?" |
| Integration check | "Does Recipe already exist in the template?" |
| Related classes | "What classes are related to Organization?" |

---

## Research Checklist

Before adding any new class or property:

- [ ] Fetch official Schema.org definition
- [ ] Check class hierarchy and inheritance
- [ ] List all properties (inherited + direct)
- [ ] Search template for existing implementation
- [ ] Determine appropriate module placement
- [ ] Map Schema.org types to Logseq types
- [ ] Determine cardinality (:one vs :many)
- [ ] Identify related classes to add together
- [ ] Check for property reuse opportunities
- [ ] Document use cases and examples
- [ ] Plan integration steps
- [ ] Estimate implementation effort
