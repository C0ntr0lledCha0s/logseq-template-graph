#!/bin/bash
# Setup script for git conventional commits hooks

set -e

echo "Setting up git hooks for conventional commits..."

# Make the commit-msg hook executable
chmod +x .git-hooks/commit-msg

# Configure git to use .git-hooks directory
git config core.hooksPath .git-hooks

echo "✓ Git hooks configured successfully!"
echo ""
echo "Commit messages will now be validated against conventional commits standard."
echo "Example valid commit: feat(templates): add Recipe class with ingredients property"
echo ""
echo "To bypass validation (not recommended): git commit --no-verify"
