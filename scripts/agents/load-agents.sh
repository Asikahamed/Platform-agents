#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Loading AI Agents"
echo "========================================="

##############################################
# Validate Environment
##############################################

if [ -z "$PLATFORM_HOME" ]; then
    echo "ERROR: PLATFORM_HOME environment variable is not set."
    exit 1
fi

AGENT_DIR="$PLATFORM_HOME/.github/agents"

echo "Platform Home : $PLATFORM_HOME"
echo "Agent Directory : $AGENT_DIR"

##############################################
# Validate Agent Directory
##############################################

if [ ! -d "$AGENT_DIR" ]; then
    echo "ERROR: Agent directory not found."
    exit 1
fi

##############################################
# Docker Agent
##############################################

DOCKER_AGENT="$AGENT_DIR/docker-agent.agent.md"

if [ ! -f "$DOCKER_AGENT" ]; then
    echo "ERROR: Docker Agent not found."
    exit 1
fi

echo "Loaded Docker Agent"

##############################################
# Terraform Agent
##############################################

TERRAFORM_AGENT="$AGENT_DIR/terraform-agent.agent.md"

if [ ! -f "$TERRAFORM_AGENT" ]; then
    echo "ERROR: Terraform Agent not found."
    exit 1
fi

echo "Loaded Terraform Agent"

##############################################
# CI/CD Agent
##############################################

CICD_AGENT="$AGENT_DIR/cicd-agent.agent.md"

if [ ! -f "$CICD_AGENT" ]; then
    echo "ERROR: CI/CD Agent not found."
    exit 1
fi

echo "Loaded CI/CD Agent"


##############################################
# Export Outputs
##############################################

if [ -n "$GITHUB_OUTPUT" ]; then
    {
        echo "docker_agent=$DOCKER_AGENT"
        echo "terraform_agent=$TERRAFORM_AGENT"
        echo "cicd_agent=$CICD_AGENT"
    } >> "$GITHUB_OUTPUT"
fi

##############################################
# Display Loaded Agents
##############################################

echo ""
echo "========== Loaded Agents =========="
echo ""

echo "Docker Agent"
echo "----------------------------------------"
cat "$DOCKER_AGENT"

echo ""
echo "Terraform Agent"
echo "----------------------------------------"
cat "$TERRAFORM_AGENT"

echo ""
echo "CI/CD Agent"
echo "----------------------------------------"
cat "$CICD_AGENT"


echo ""
echo "========================================="
echo "All AI Agents Loaded Successfully"
echo "========================================="