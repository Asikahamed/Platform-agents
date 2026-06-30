#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Generate DevOps Assets"
echo "========================================="

##############################################
# Validate Inputs
##############################################

if [ -z "$APP_PATH" ]; then
    echo "APP_PATH is empty"
    exit 1
fi

if [ -z "$DOCKER_TEMPLATE" ]; then
    echo "DOCKER_TEMPLATE is empty"
    exit 1
fi

if [ -z "$TERRAFORM_TEMPLATE" ]; then
    echo "TERRAFORM_TEMPLATE is empty"
    exit 1
fi

if [ -z "$CICD_TEMPLATE" ]; then
    echo "CICD_TEMPLATE is empty"
    exit 1
fi

echo "Application Path : $APP_PATH"

##############################################
# Docker Assets
##############################################

if [ ! -f "$APP_PATH/Dockerfile" ]; then

    echo "Generating Dockerfile..."

    cp "$DOCKER_TEMPLATE/Dockerfile" \
       "$APP_PATH/Dockerfile"

    cp "$DOCKER_TEMPLATE/.dockerignore" \
       "$APP_PATH/.dockerignore"

else

    echo "Dockerfile already exists. Skipping."

fi

##############################################
# Terraform Assets
##############################################

if [ ! -d "$APP_PATH/terraform" ]; then

    echo "Generating Terraform..."

    mkdir -p "$APP_PATH/terraform"

    cp -R "$TERRAFORM_TEMPLATE/"* \
          "$APP_PATH/terraform/"

else

    echo "Terraform already exists. Skipping."

fi

##############################################
# GitHub Actions
##############################################

if [ ! -d "$APP_PATH/.github/workflows" ]; then

    echo "Generating GitHub Actions..."

    mkdir -p "$APP_PATH/.github/workflows"

    cp "$CICD_TEMPLATE/ci-cd.yml" \
       "$APP_PATH/.github/workflows/ci-cd.yml"

    cp platform-templates/security/trivy/trivy.yml \
       "$APP_PATH/.github/workflows/trivy.yml"

    cp platform-templates/security/gitleaks/gitleaks.yml \
       "$APP_PATH/.github/workflows/gitleaks.yml"

else

    echo "GitHub workflows already exist. Skipping."

fi

##############################################
# Generated Assets Summary
##############################################

echo ""
echo "========================================="
echo "Generated Assets"
echo "========================================="

find "$APP_PATH" \
    \( -name Dockerfile \
    -o -name ".dockerignore" \
    -o -name "*.tf" \
    -o -name "*.yml" \)

echo ""

##############################################
# Git Status
##############################################

echo "========================================="
echo "Git Status"
echo "========================================="

git status

echo ""

git diff --name-only || true

echo ""

echo "Asset generation completed."