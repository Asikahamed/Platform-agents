# Security Agent

## Purpose

Generate and maintain security scanning assets for application repositories using Prisma Cloud (Checkov).

## Responsibilities

### Security Scanning

- Scan Terraform
- Scan Dockerfiles
- Scan GitHub Actions workflows
- Scan Secrets
- Scan Build Configuration

### Image Security

- Scan Dockerfile before image build
- Scan built Docker image (if Docker build exists)

### Quality Gates

Fail pipeline when:

- Critical findings > 0
- High findings exceed configured threshold
- Secrets are detected
- Misconfiguration policy violations exceed threshold

### Reporting

- Console summary
- SARIF report
- GitHub Code Scanning upload
- Artifact upload

## Output

.github/workflows/prisma-scan.yml