#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Create Pull Request"
echo "========================================="

##############################################
# Validate Inputs
##############################################

if [ "$CHANGES" != "true" ]; then
    echo "No changes detected."
    echo "Skipping Pull Request creation."
    exit 0
fi

if [ -z "$BRANCH_NAME" ]; then
    echo "Branch name is empty."
    exit 1
fi

##############################################
# Create Pull Request
##############################################

echo "Creating Pull Request..."

gh api \
  repos/$GITHUB_REPOSITORY/pulls \
  -f title="Platform Agent generated DevOps assets" \
  -f head="$BRANCH_NAME" \
  -f base="main" \
  -f body="## 🤖 Platform Agent

The Platform Agent analyzed the repository and generated DevOps assets.

### Generated Assets

- Dockerfile
- .dockerignore
- Terraform
- GitHub Actions
- Trivy
- Gitleaks

Please review and merge."

echo ""
echo "========================================="
echo "Pull Request Created Successfully"
echo "========================================="