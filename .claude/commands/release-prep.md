# Release Preparation

Cut a release of `schema-library.edn` and `schema-presets.edn` from `dev`.

Releases are manual. `auto-release.yml` runs in dry-run mode and only previews the next version; it creates no tag. The authoritative steps are in [docs/developer-guide/ci-cd-pipeline.md](../../docs/developer-guide/ci-cd-pipeline.md#release-flow). This command walks through them.

## Usage

```
/release-prep [version]
```

`version` is optional (`2.5.0`, `patch`, `minor`, `major`). Without it, pick from the commits since the last tag: `feat` -> minor, `fix` only -> patch, `!` or `BREAKING` -> major.

## Steps

### 1. Check the starting point

```bash
git fetch origin --tags
git switch dev && git pull --ff-only
git describe --tags --abbrev=0 origin/main      # last release
git log --oneline <last-tag>..origin/dev        # what this release contains
gh pr list --base dev --state open              # anything still waiting to land?
```

Stop if the working tree is dirty or a PR meant for this release is still open.

### 2. Prepare the version (PR into `dev`)

```bash
git switch -c chore/release-X.Y.Z
# package.json: "version": "X.Y.Z"
# CHANGELOG.md: new entry at the top, hand-written in the style of the existing ones:
#   ## **X.Y.Z**&emsp;<sub><sup>YYYY-MM-DD ([vPREV...vX.Y.Z](https://github.com/C0ntr0lledCha0s/logseq-template-graph/compare/vPREV...vX.Y.Z))</sup></sub>
#   one-line summary, then ### Features & Enhancements / ### Fixes / ### Manual steps (only if users must change their graph)
bb test && bb validate && bb publish-library && bb check-library
git add package.json CHANGELOG.md library/
git commit -m "chore(release): prepare version X.Y.Z"
git push -u origin chore/release-X.Y.Z
gh pr create --base dev --title "chore(release): prepare version X.Y.Z" --body "..."
```

Wait for CI, then squash-merge.

### 3. Merge `dev` into `main`

```bash
gh pr create --base main --head dev --title "release: merge dev into main for vX.Y.Z" --body "Releases vX.Y.Z (#...)."
# after CI passes:
gh pr merge <n> --merge --subject "release: merge dev into main for vX.Y.Z" --body ""
```

Keep that subject. A subject containing `Merge pull request` or `chore(release):` makes `sync-branches.yml` skip syncing `main` back into `dev`.

### 4. Tag and publish

```bash
git fetch origin
git tag -a vX.Y.Z origin/main -m "Release vX.Y.Z"
git push origin vX.Y.Z
gh run list --workflow release.yml --limit 1     # watch it finish
gh release view vX.Y.Z --json assets --jq '.assets[].name'
```

The release must have exactly `schema-library.edn` and `schema-presets.edn`, stamped with `X.Y.Z`.

### 5. Finish

- Check `dev` received the `chore(sync): sync main → dev` commit.
- Close issues that `Closes #N` did not close, linking the release.

## When GitHub misbehaves

- **`Internal Server Error`, `502` or `Merge already in progress`:** check [githubstatus.com](https://www.githubstatus.com). Confirm the ref did not move (`git ls-remote origin`, `gh pr view <n> --json state`) before retrying, so nothing happens twice.
- **`release.yml` fails at Create GitHub Release** (for example `Cannot read properties of undefined`) and no release exists: `gh run rerun <run-id> --failed`.
