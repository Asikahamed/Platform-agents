#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Repository Analysis"
echo "========================================="

##############################################
# Detect Application
##############################################

APP_PATH=$(find . -type f -name "pom.xml" | head -1 | xargs dirname)

if [ -z "$APP_PATH" ]; then
    echo "No Java application found."
    exit 1
fi

echo "Application Path : $APP_PATH"

echo "app_path=$APP_PATH" >> "$GITHUB_OUTPUT"

##############################################
# Language
##############################################

echo "language=java" >> "$GITHUB_OUTPUT"

##############################################
# Build Tool
##############################################

echo "build_tool=maven" >> "$GITHUB_OUTPUT"

##############################################
# Java Version
##############################################

JAVA_VERSION=$(grep -oPm1 '(?<=<java.version>)[^<]+' "$APP_PATH/pom.xml" || true)

if [ -z "$JAVA_VERSION" ]; then
    JAVA_VERSION=17
fi

echo "Detected Java Version : $JAVA_VERSION"

echo "java_version=$JAVA_VERSION" >> "$GITHUB_OUTPUT"

##############################################
# Framework
##############################################

if grep -qi "spring-boot" "$APP_PATH/pom.xml"; then
    FRAMEWORK="springboot"
else
    FRAMEWORK="java"
fi

echo "Detected Framework : $FRAMEWORK"

echo "framework=$FRAMEWORK" >> "$GITHUB_OUTPUT"

##############################################
# Deployment Target
##############################################

DEPLOYMENT_TARGET="cloudrun"

echo "deployment_target=$DEPLOYMENT_TARGET" >> "$GITHUB_OUTPUT"

##############################################
# Dockerfile
##############################################

if [ -f "$APP_PATH/Dockerfile" ]; then
    HAS_DOCKERFILE=true
else
    HAS_DOCKERFILE=false
fi

echo "has_dockerfile=$HAS_DOCKERFILE" >> "$GITHUB_OUTPUT"

##############################################
# Terraform
##############################################

if [ -d "$APP_PATH/terraform" ]; then
    HAS_TERRAFORM=true
else
    HAS_TERRAFORM=false
fi

echo "has_terraform=$HAS_TERRAFORM" >> "$GITHUB_OUTPUT"

##############################################
# GitHub Actions
##############################################

HAS_WORKFLOWS=false

WORKFLOW_DIR="$APP_PATH/.github/workflows"

if [ -d "$WORKFLOW_DIR" ]; then

    echo ""
    echo "Inspecting GitHub workflows..."

    for workflow in "$WORKFLOW_DIR"/*.yml "$WORKFLOW_DIR"/*.yaml; do

        [ -e "$workflow" ] || continue

        FILE_NAME=$(basename "$workflow")

        ##########################################################
        # Ignore Platform Agent caller workflow
        ##########################################################

        if grep -q "Platform Agent" "$workflow" && \
           grep -q "platform-agent-reusable.yml" "$workflow"; then

            echo "Ignoring Platform Agent caller workflow: $FILE_NAME"
            continue

        fi

        ##########################################################
        # Found a real CI/CD workflow
        ##########################################################

        echo "Detected application workflow: $FILE_NAME"
        HAS_WORKFLOWS=true
        break

    done

fi

echo "has_workflows=$HAS_WORKFLOWS" >> "$GITHUB_OUTPUT"

##############################################
# Security Scan (Prisma / Checkov)
##############################################

HAS_SECURITY_SCAN=false

if [ -d "$APP_PATH/.github/workflows" ]; then

    for workflow in "$APP_PATH/.github/workflows"/*.yml "$APP_PATH/.github/workflows"/*.yaml
    do

        [ -e "$workflow" ] || continue

        if grep -qi "checkov\|bridgecrew\|prisma" "$workflow"; then
            HAS_SECURITY_SCAN=true
            break
        fi

    done

fi

echo "has_security_scan=$HAS_SECURITY_SCAN" >> "$GITHUB_OUTPUT"

##############################################
# Repository Summary
##############################################

echo ""
echo "========== Repository Summary =========="

echo "Application Path      : $APP_PATH"
echo "Language              : java"
echo "Framework             : $FRAMEWORK"
echo "Build Tool            : maven"
echo "Java Version          : $JAVA_VERSION"
echo "Deployment Target     : $DEPLOYMENT_TARGET"

echo ""

echo "Dockerfile Present    : $HAS_DOCKERFILE"
echo "Terraform Present     : $HAS_TERRAFORM"
echo "GitHub Workflow       : $HAS_WORKFLOWS"
echo "Security Scan         : $HAS_SECURITY_SCAN"

echo "========================================="
