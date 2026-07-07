#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Decision Engine"
echo "========================================="

##############################################
# Validate Environment
##############################################

if [ -z "$PLATFORM_HOME" ]; then
    echo "ERROR: PLATFORM_HOME is not set."
    exit 1
fi

##############################################
# Repository Context
##############################################

LANGUAGE="${LANGUAGE:-java}"
BUILD_TOOL="${BUILD_TOOL:-maven}"
FRAMEWORK="${FRAMEWORK:-springboot}"
DEPLOYMENT_TARGET="${DEPLOYMENT_TARGET:-cloudrun}"

echo "Language          : $LANGUAGE"
echo "Framework         : $FRAMEWORK"
echo "Build Tool        : $BUILD_TOOL"
echo "Deployment Target : $DEPLOYMENT_TARGET"

echo ""

##############################################
# Docker Template
##############################################

case "$LANGUAGE" in

    java)
        DOCKER_TEMPLATE="$PLATFORM_HOME/platform-templates/docker/java"
        ;;

    dotnet)
        DOCKER_TEMPLATE="$PLATFORM_HOME/platform-templates/docker/dotnet"
        ;;

    *)
        echo "Unsupported language: $LANGUAGE"
        exit 1
        ;;
esac

##############################################
# Terraform Template
##############################################

case "$DEPLOYMENT_TARGET" in

    cloudrun)
        TERRAFORM_TEMPLATE="$PLATFORM_HOME/platform-templates/terraform/gcp-cloudrun"
        ;;

    gke)
        TERRAFORM_TEMPLATE="$PLATFORM_HOME/platform-templates/terraform/gke"
        ;;

    *)
        echo "Unsupported deployment target."
        exit 1
        ;;
esac

##############################################
# CI/CD Template
##############################################

case "$LANGUAGE-$BUILD_TOOL-$DEPLOYMENT_TARGET" in

    java-maven-cloudrun)
        CICD_TEMPLATE="$PLATFORM_HOME/platform-templates/github-actions/java-maven-cloudrun"
        ;;

    dotnet-*-*)
        CICD_TEMPLATE="$PLATFORM_HOME/platform-templates/github-actions/dotnet"
        ;;

    *)
        echo "No matching CI/CD template."
        exit 1
        ;;
esac

##############################################
# Security Template
##############################################

case "$LANGUAGE" in

    java)
        SECURITY_TEMPLATE="$PLATFORM_HOME/platform-templates/security/checkov"
        ;;

    dotnet)
        SECURITY_TEMPLATE="$PLATFORM_HOME/platform-templates/security/checkov"
        ;;

    *)
        echo "No matching Security template."
        exit 1
        ;;

esac

##############################################
# Export Outputs
##############################################

echo "docker_template=$DOCKER_TEMPLATE" >> "$GITHUB_OUTPUT"
echo "terraform_template=$TERRAFORM_TEMPLATE" >> "$GITHUB_OUTPUT"
echo "cicd_template=$CICD_TEMPLATE" >> "$GITHUB_OUTPUT"
echo "security_template=$SECURITY_TEMPLATE" >> "$GITHUB_OUTPUT"

echo ""
echo "========================================="
echo "Selected Templates"
echo "========================================="
echo "Docker     : $DOCKER_TEMPLATE"
echo "Terraform  : $TERRAFORM_TEMPLATE"
echo "CI/CD      : $CICD_TEMPLATE"
echo "Security   : $SECURITY_TEMPLATE"
