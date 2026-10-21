# Git conventional commits validation hook (PowerShell version for Windows)
# This hook validates commit messages against the conventional commits standard

param($CommitMsgFile)

# Run conventional commits validation
# Quote the path to handle spaces correctly
npx --no -- git-conventional-commits commit-msg-hook "`"$CommitMsgFile`""

exit $LASTEXITCODE
