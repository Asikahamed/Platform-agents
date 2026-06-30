#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Decision Engine"
echo "========================================="

##############################################
# Read Repository Context
##############################################

LANGUAGE="${LANGUAGE:-java}"
BUILD_TOOL="${BUILD_TOOL:-maven}"
FRAMEWORK="${FRAMEWORK:-springboot}"
DEPLOYMENT_TARGET="${DEPLOYMENT_TARGET:-cloudrun}"

echo "Repository Context"
echo "------------------"
echo "Language          : $LANGUAGE"
echo "Framework         : $FRAMEWORK"
echo "Build Tool        : $BUILD_TOOL"
echo "Deployment Target : $DEPLOYMENT_TARGET"

echo ""

##############################################
# Docker Template Selection
##############################################

DOCKER_TEMPLATE=""

case "$LANGUAGE" in
    java)

        DOCKER_TEMPLATE="platform-templates/docker/java"
        ;;

    dotnet)

        DOCKER_TEMPLATE="platform-templates/docker/dotnet"
        ;;

    *)

        echo "Unsupported language: $LANGUAGE"
        exit 1
        ;;
esac

##############################################
# Terraform Template Selection
##############################################

TERRAFORM_TEMPLATE=""

case "$DEPLOYMENT_TARGET" in

    cloudrun)

        TERRAFORM_TEMPLATE="platform-templates/terraform/gcp-cloudrun"
        ;;

    gke)

        TERRAFORM_TEMPLATE="platform-templates/terraform/gke"
        ;;

    *)

        echo "Unsupported deployment target: $DEPLOYMENT_TARGET"
        exit 1
        ;;
esac

##############################################
# CI/CD Template Selection
##############################################

CICD_TEMPLATE=""

if [ "$LANGUAGE" = "java" ] && [ "$BUILD_TOOL" = "maven" ]; then

    CICD_TEMPLATE="platform-templates/github-actions/java-maven-cloudrun"

elif [ "$LANGUAGE" = "dotnet" ]; then

    CICD_TEMPLATE="platform-templates/github-actions/dotnet"

else

    echo "No matching CI/CD template found."
    exit 1

fi

##############################################
# Export Outputs
##############################################

echo "docker_template=$DOCKER_TEMPLATE" >> "$GITHUB_OUTPUT"

echo "terraform_template=$TERRAFORM_TEMPLATE" >> "$GITHUB_OUTPUT"

echo "cicd_template=$CICD_TEMPLATE" >> "$GITHUB_OUTPUT"

##############################################
# Decision Summary
##############################################

echo ""
echo "========== Agent Decisions =========="

echo "Docker Template"
echo "----------------"
echo "$DOCKER_TEMPLATE"

echo ""

echo "Terraform Template"
echo "-------------------"
echo "$TERRAFORM_TEMPLATE"

echo ""

echo "CI/CD Template"
echo "---------------"
echo "$CICD_TEMPLATE"

echo ""

echo "====================================="
echo "Decision Engine Completed"
echo "====================================="