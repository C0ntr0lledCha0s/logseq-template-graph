# UUID Reference Validation

This document explains the UUID reference validation system implemented for the Logseq Template Graph project.

## Overview

The validation system automatically detects and prevents broken UUID references in property and class descriptions. It validates two types of broken references:

- **Type A**: Legacy Logseq block UUIDs that should be class names
- **Type B**: Inverse property UUID placeholders that should be actual property names

## Why UUID Validation Matters

Broken UUID references in descriptions cause:
- ❌ Broken wiki-links in Logseq UI
- ❌ Poor documentation quality
- ❌ Confusion for template users
- ❌ Maintenance nightmares

## How It Works

### 1. Validation Script

**File:** `scripts/validate-refs.clj`

The Babashka-based validation script:
1. Scans all `.edn` files in `source/` directory
2. Builds a registry of all properties and classes
3. Extracts all `[[UUID]]` patterns from descriptions
4. Identifies two types of broken UUIDs:
   - Legacy Logseq block UUIDs (e.g., `67ceb6fc-...`)
   - Inverse property placeholders (e.g., `00000002-...`)
5. Provides actionable fix suggestions

### 2. Automated Detection

The script uses regex patterns to identify broken UUIDs:

```clojure
;; Legacy Logseq block UUIDs
(defn is-legacy-uuid? [uuid]
  (or (str/starts-with? uuid "67")
      (str/starts-with? uuid "68")))

;; Inverse property placeholders
(defn is-inverse-property-placeholder? [uuid]
  (str/starts-with? uuid "00000002-"))
```

### 3. Fix Suggestions

The validator provides context-aware fix suggestions:

**Type A Example:**
```
[ERROR] Broken: [[67ceb6fc-66f6-48a9-b572-2a9b578c3dbf]]
[FIX]    Use:    [[Organization]]
Context: "The official name of the [[67ceb6fc-...]] ..."
```

**Type B Example:**
```
[ERROR] Broken: [[00000002-1192-4192-1100-000000000000]]
[FIX]    Use:    [[member]]
Property: memberOf
Schema.org inverse: member
```

## Running Validation

### Manual Validation

```bash
# Run validation directly
bb scripts/validate-refs.clj

# Or via npm
npm run validate
```

### Automated Validation

Validation runs automatically:

1. **Pre-push hook** - Validates before `git push`
2. **CI/CD pipeline** - Validates on pull requests
3. **Post-commit hook** - Validates after modifying `source/`

## Type A: Legacy Logseq Block UUIDs

### Problem

When exporting from Logseq, some wiki-links to classes were converted to UUIDs instead of class names:

```clojure
;; ❌ Broken
:logseq.property/description
"The official name of the [[67ceb6fc-66f6-48a9-b572-2a9b578c3dbf]] ..."

;; ✅ Fixed
:logseq.property/description
"The official name of the [[Organization]] ..."
```

### UUID Mappings

The following legacy UUIDs have been mapped:

| UUID Prefix | Class Name | Count |
|-------------|------------|-------|
| `67ceb6fc-...` | Organization | 15 |
| `67ceb474-...` | Person | 8 |
| `67ea5b18-...` | CreativeWork | 6 |
| `680750e7-...` | FamilyGroup | 1 |
| `67cff158-...` | Organization | 2 |

**Total Type A errors fixed:** 32

### How to Fix

Run the automated fix script:

```powershell
# PowerShell (Windows)
.\scripts\fix-broken-uuids.ps1
```

```bash
# Bash (Linux/Mac)
bash scripts/fix-broken-uuids.sh
```

## Type B: Inverse Property Placeholders

### Problem

Inverse property references used placeholder UUIDs instead of actual property names:

```clojure
;; ❌ Broken
:logseq.property/description
"An Organization to which this Person belongs.
Inverse property: [[00000002-1192-4192-1100-000000000000]]"

;; ✅ Fixed
:logseq.property/description
"An Organization to which this Person belongs.
Inverse property: [[member]]"
```

### Schema.org Inverse Property Resolution

The validation system uses Schema.org to identify correct inverse properties:

| Property | Inverse Property | UUID Fixed |
|----------|------------------|------------|
| `memberOf` | `member` | `00000002-1192-...` |
| `parentOrganization` | `subOrganization` | `00000002-1132-...` |
| `subOrganization` | `parentOrganization` | `00000002-1007-...` |
| `alumniOf` | `alumni` | `00000002-9863-...` |
| `alumni` | `alumniOf` | `00000002-7815-...` |
| `member` | `memberOf` | `00000002-2693-...` |
| `creator` | `author` | `00000002-1170-...` |
| `contributor` | `Event` | `00000002-1301-...` |
| `location` | `Event` | `00000002-1301-...` |

**Total Type B errors fixed:** 11

### How to Fix

Run the automated fix script:

```powershell
# PowerShell (Windows)
.\scripts\fix-inverse-properties.ps1
```

## Validation Output

### Success

```
╔══════════════════════════════════════════════════╗
║   Logseq Template Reference Validator           ║
╚══════════════════════════════════════════════════╝

[INFO] Found 21 EDN files to validate

[SUCCESS] Registry built: 335 properties, 135 classes

[INFO] Validating UUID references in descriptions...

[SUCCESS] ✓ All UUID validations passed!
[SUCCESS] ✓ 335 properties validated
[SUCCESS] ✓ 135 classes validated
[SUCCESS] ✓ All UUID references valid
```

### Failure

```
==================================================
         VALIDATION ERRORS FOUND
==================================================

Type A: Legacy Logseq Block UUIDs (14 errors)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

File: source\common\properties.edn
  Item: legalName
  Broken: [[67ceb6fc-66f6-48a9-b572-2a9b578c3dbf]]
  Fix:    [[Organization]]
  Context: The official name of the [[67ceb6fc-...]]

Type B: Inverse Property Placeholders (11 errors)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

File: source\organization\properties.edn
  Property: memberOf
  Broken: [[00000002-1192-4192-1100-000000000000]]
  Schema.org inverse: member
  Fix: [[member]]
  Context: An Organization (or ProgramMembership)...

==================================================
         TOTAL ERRORS: 25
==================================================
```

## Integration Points

### 1. Validate Script (`scripts/validate.sh`)

```bash
# Run UUID reference validation on source files
if [ -d "source" ]; then
    if command -v bb >/dev/null 2>&1; then
        bb scripts/validate-refs.clj
    fi
fi
```

### 2. CI/CD Pipeline (`.github/workflows/validate.yml`)

```yaml
- name: Validate UUID references
  run: |
    echo "Validating UUID references in source files..."
    if [ -d "source" ]; then
      bb scripts/validate-refs.clj
    fi
```

### 3. Git Hooks (`.git-hooks/pre-push.ps1`)

```powershell
if (Test-Path "source") {
    if (Get-Command bb -ErrorAction SilentlyContinue) {
        bb scripts/validate-refs.clj
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[ERROR] UUID reference validation failed"
            exit 1
        }
    }
}
```

## Troubleshooting

### Validation Script Fails

**Issue:** `bb: command not found`

**Fix:** Install Babashka from https://babashka.org/

```bash
# Linux/Mac
bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)

# Windows (via scoop)
scoop install babashka
```

### False Positives

If the validator incorrectly flags a UUID:

1. Check if the UUID is a valid Logseq class/property reference
2. Update the validation script's UUID pattern matching
3. File an issue with details

### Schema.org Lookup Failures

If inverse property lookup fails:

1. The property might not exist in Schema.org
2. Manually identify the inverse property
3. Update `scripts/fix-inverse-properties.ps1` with the correct mapping

## Best Practices

### For Developers

1. ✅ **Always use class/property names** in wiki-links, not UUIDs
2. ✅ **Run validation before committing** to catch issues early
3. ✅ **Use Schema.org** to find correct inverse properties
4. ✅ **Test validation** after making changes to source files

### For Contributors

1. ✅ **Check validation passes** before submitting PRs
2. ✅ **Use fix scripts** instead of manual edits when possible
3. ✅ **Document new UUID patterns** if discovered
4. ✅ **Update mappings** if Schema.org relationships change

## Related Issues

- **Issue #20**: Add validation script for broken UUID references
- **Issue #27**: Fix broken UUID references in source files

## See Also

- [CI/CD Pipeline Documentation](ci-cd-pipeline.md)
- [Development Workflow](../modular/quickstart.md)
- [Technical Reference](../architecture/technical-reference.md)

---

**Last Updated:** November 2025
**Validation System Version:** 1.0.0
