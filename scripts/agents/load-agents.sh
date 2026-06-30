#!/bin/bash

set -e

echo "========================================="
echo "Platform Agent - Loading AI Agents"
echo "========================================="

AGENT_DIR=".github/agents"

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
# Kubernetes Agent
##############################################

KUBERNETES_AGENT="$AGENT_DIR/kubernetes-agent.agent.md"

if [ -f "$KUBERNETES_AGENT" ]; then
    echo "Loaded Kubernetes Agent"
else
    echo "Kubernetes Agent not found (optional)"
fi

##############################################
# Export Paths
##############################################

echo "docker_agent=$DOCKER_AGENT" >> "$GITHUB_OUTPUT"
echo "terraform_agent=$TERRAFORM_AGENT" >> "$GITHUB_OUTPUT"
echo "cicd_agent=$CICD_AGENT" >> "$GITHUB_OUTPUT"
echo "kubernetes_agent=$KUBERNETES_AGENT" >> "$GITHUB_OUTPUT"

##############################################
# Display Loaded Agents
##############################################

echo ""
echo "========== Loaded Agents =========="

echo "Docker Agent"
echo "-----------------------------------"
cat "$DOCKER_AGENT"

echo ""

echo "Terraform Agent"
echo "-----------------------------------"
cat "$TERRAFORM_AGENT"

echo ""

echo "CI/CD Agent"
echo "-----------------------------------"
cat "$CICD_AGENT"

echo ""

if [ -f "$KUBERNETES_AGENT" ]; then
    echo "Kubernetes Agent"
    echo "-----------------------------------"
    cat "$KUBERNETES_AGENT"
fi

echo ""

echo "========================================="
echo "All AI Agents Loaded Successfully"
echo "========================================="