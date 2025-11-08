#!/bin/bash
# Setup script for git hooks (conventional commits + build validation)

set -e

echo "Setting up git hooks..."

# Make all hooks executable
chmod +x .git-hooks/commit-msg
chmod +x .git-hooks/post-commit
chmod +x .git-hooks/pre-push
chmod +x .git-hooks/post-merge

# Configure git to use .git-hooks directory
git config core.hooksPath .git-hooks

echo "✓ Git hooks configured successfully!"
echo ""
echo "Active hooks:"
echo "  • commit-msg   - Validates conventional commits format"
echo "  • post-commit  - Validates build after source/ changes"
echo "  • pre-push     - Comprehensive validation before pushing"
echo "  • post-merge   - Auto-rebuild after merge/pull"
echo ""
echo "Example valid commit: feat(templates): add Recipe class with ingredients property"
echo ""
echo "To bypass hooks (not recommended): git commit --no-verify"
