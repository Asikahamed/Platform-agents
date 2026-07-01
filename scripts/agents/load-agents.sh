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

echo "Platform Home   : $PLATFORM_HOME"
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
# Kubernetes Agent (Optional)
##############################################

KUBERNETES_AGENT="$AGENT_DIR/kubernetes-agent.agent.md"

if [ -f "$KUBERNETES_AGENT" ]; then
    echo "Loaded Kubernetes Agent"
else
    echo "Kubernetes Agent not found (optional)"
fi

##############################################
# Export Outputs
##############################################

echo "docker_agent=$DOCKER_AGENT" >> "$GITHUB_OUTPUT"
echo "terraform_agent=$TERRAFORM_AGENT" >> "$GITHUB_OUTPUT"
echo "cicd_agent=$CICD_AGENT" >> "$GITHUB_OUTPUT"

if [ -f "$KUBERNETES_AGENT" ]; then
    echo "kubernetes_agent=$KUBERNETES_AGENT" >> "$GITHUB_OUTPUT"
fi

##############################################
# Display Loaded Agents
##############################################

echo ""
echo "========================================="
echo "Loaded AI Agents"
echo "========================================="

echo ""
echo "Docker Agent"
echo "-----------------------------------------"
cat "$DOCKER_AGENT"

echo ""
echo "Terraform Agent"
echo "-----------------------------------------"
cat "$TERRAFORM_AGENT"

echo ""
echo "CI/CD Agent"
echo "-----------------------------------------"
cat "$CICD_AGENT"

if [ -f "$KUBERNETES_AGENT" ]; then
    echo ""
    echo "Kubernetes Agent"
    echo "-----------------------------------------"
    cat "$KUBERNETES_AGENT"
fi

echo ""
echo "========================================="
echo "All AI Agents Loaded Successfully"
echo "========================================="
