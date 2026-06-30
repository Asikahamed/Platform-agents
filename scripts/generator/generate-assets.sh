#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Generate DevOps Assets"
echo "========================================="

##############################################################
# Validate Required Variables
##############################################################

REQUIRED_VARS=(
  APP_HOME
  APP_PATH
  PLATFORM_HOME
  DOCKER_TEMPLATE
  TERRAFORM_TEMPLATE
  CICD_TEMPLATE
)

for VAR in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!VAR}" ]; then
        echo "ERROR: $VAR is not set."
        exit 1
    fi
done

##############################################################
# Directories
##############################################################

TARGET_DIR="$APP_HOME/$APP_PATH"

echo "Application Home : $APP_HOME"
echo "Application Path : $APP_PATH"
echo "Target Directory : $TARGET_DIR"
echo "Platform Home    : $PLATFORM_HOME"

echo ""

##############################################################
# Validate Target Directory
##############################################################

if [ ! -d "$TARGET_DIR" ]; then
    echo "ERROR: Target directory does not exist."
    exit 1
fi

##############################################################
# Docker Assets
##############################################################

if [ ! -f "$TARGET_DIR/Dockerfile" ]; then

    echo "Generating Docker assets..."

    cp \
      "$PLATFORM_HOME/$DOCKER_TEMPLATE/Dockerfile" \
      "$TARGET_DIR/Dockerfile"

    cp \
      "$PLATFORM_HOME/$DOCKER_TEMPLATE/.dockerignore" \
      "$TARGET_DIR/.dockerignore"

else

    echo "Dockerfile already exists. Skipping."

fi

##############################################################
# Terraform Assets
##############################################################

if [ ! -d "$TARGET_DIR/terraform" ]; then

    echo "Generating Terraform assets..."

    mkdir -p "$TARGET_DIR/terraform"

    cp -R \
      "$PLATFORM_HOME/$TERRAFORM_TEMPLATE/"* \
      "$TARGET_DIR/terraform/"

else

    echo "Terraform already exists. Skipping."

fi

##############################################################
# GitHub Actions
##############################################################

if [ "$HAS_WORKFLOWS" = "false" ]; then

    echo "Generating GitHub Actions..."

    mkdir -p "$TARGET_DIR/.github/workflows"

    cp \
      "$PLATFORM_HOME/$CICD_TEMPLATE/ci-cd.yml" \
      "$TARGET_DIR/.github/workflows/ci-cd.yml"

else

    echo "Application CI/CD pipeline already exists. Skipping."

fi

##############################################################
# Generated Assets
##############################################################

echo ""
echo "========================================="
echo "Generated Assets"
echo "========================================="

find "$TARGET_DIR" \
    \( \
    -name Dockerfile \
    -o -name ".dockerignore" \
    -o -name "*.tf" \
    -o -name "*.tfvars" \
    -o -name "*.yml" \
    -o -name "*.yaml" \
    \)

echo ""

##############################################################
# Git Status
##############################################################

echo "========================================="
echo "Git Status"
echo "========================================="

cd "$APP_HOME"

git status

echo ""

git diff --name-only || true

echo ""

echo "========================================="
echo "Platform Agent completed successfully."
echo "========================================="