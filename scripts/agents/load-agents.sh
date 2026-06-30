#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Loading AI Agents"
echo "========================================="

##############################################
# Validate Environment
##############################################

if [ -z "$PLATFORM_HOME" ]; then
    echo "ERROR: PLATFORM_HOME is not set."
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

[ -f "$DOCKER_AGENT" ] || {
    echo "Docker Agent not found."
    exit 1
}

##############################################
# Terraform Agent
##############################################

TERRAFORM_AGENT="$AGENT_DIR/terraform-agent.agent.md"

[ -f "$TERRAFORM_AGENT" ] || {
    echo "Terraform Agent not found."
    exit 1
}

##############################################
# CI/CD Agent
##############################################

CICD_AGENT="$AGENT_DIR/cicd-agent.agent.md"

[ -f "$CICD_AGENT" ] || {
    echo "CI/CD Agent not found."
    exit 1
}

##############################################
# Export Outputs
##############################################

echo "docker_agent=$DOCKER_AGENT" >> "$GITHUB_OUTPUT"
echo "terraform_agent=$TERRAFORM_AGENT" >> "$GITHUB_OUTPUT"
echo "cicd_agent=$CICD_AGENT" >> "$GITHUB_OUTPUT"

echo ""
echo "Loaded Docker Agent"
echo "Loaded Terraform Agent"
echo "Loaded CI/CD Agent"

echo ""
echo "========================================="
echo "All AI Agents Loaded Successfully"
echo "========================================="