#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Git Operations"
echo "========================================="

##############################################
# Validate Environment
##############################################

if [ -z "$GH_TOKEN" ]; then
    echo "ERROR: GH_TOKEN is not set."
    exit 1
fi

if [ -z "$GITHUB_REPOSITORY" ]; then
    echo "ERROR: GITHUB_REPOSITORY is not set."
    exit 1
fi

##############################################
# Configure Git
##############################################

git config user.name "platform-agent"
git config user.email "platform-agent@users.noreply.github.com"

echo "Git configured."

##############################################
# Configure Authenticated Remote
##############################################

echo "Configuring authenticated remote..."

git remote set-url origin \
"https://x-access-token:${GH_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

git remote -v

##############################################
# Create Feature Branch
##############################################

BRANCH_NAME="platform-agent-$(date +%Y%m%d-%H%M%S)"

echo "Creating branch: $BRANCH_NAME"

git checkout -b "$BRANCH_NAME"

echo "branch_name=$BRANCH_NAME" >> "$GITHUB_OUTPUT"

##############################################
# Stage Changes
##############################################

git add .

##############################################
# Check for Changes
##############################################

if git diff --cached --quiet; then

    echo ""
    echo "========================================="
    echo "No changes detected."
    echo "Skipping commit and push."
    echo "========================================="

    echo "changes=false" >> "$GITHUB_OUTPUT"

    exit 0

fi

echo "changes=true" >> "$GITHUB_OUTPUT"

##############################################
# Commit Changes
##############################################

git commit -m "Platform Agent generated DevOps assets"

##############################################
# Push Branch
##############################################

echo "Pushing branch..."

git push --set-upstream origin "$BRANCH_NAME"

##############################################
# Summary
##############################################

echo ""
echo "========================================="
echo "Git Summary"
echo "========================================="

echo "Repository : $GITHUB_REPOSITORY"
echo "Branch     : $BRANCH_NAME"

echo ""

git log --oneline -1

echo ""

git status

echo ""

echo "Git operations completed successfully."