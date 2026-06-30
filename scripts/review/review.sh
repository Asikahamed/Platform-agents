#!/bin/bash

set -e

echo "Generating Platform Review..."

cat <<EOF >> "$GITHUB_STEP_SUMMARY"

# 🤖 Platform Agent Review

## Repository Analysis

| Property | Value |
|----------|-------|
| Language | ${LANGUAGE} |
| Framework | ${FRAMEWORK} |
| Build Tool | ${BUILD_TOOL} |
| Java Version | ${JAVA_VERSION} |
| Deployment Target | ${DEPLOYMENT_TARGET} |

---

## Selected Templates

| Asset | Template |
|-------|----------|
| Docker | ${DOCKER_TEMPLATE} |
| Terraform | ${TERRAFORM_TEMPLATE} |
| GitHub Actions | ${CICD_TEMPLATE} |

---

## Generated Assets

- ✅ Dockerfile
- ✅ .dockerignore
- ✅ Terraform
- ✅ GitHub Actions
- ✅ Trivy
- ✅ Gitleaks

---

## Git Status

| Property | Value |
|----------|-------|
| Branch | ${BRANCH_NAME} |
| Changes | ${CHANGES} |

EOF

echo "Platform Review Completed."