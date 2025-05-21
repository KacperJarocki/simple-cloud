# simple-cloud

This repository contains Terraform code for provisioning a sample Azure infrastructure. It is designed to deploy a demo application environment, divided into multiple modules and environments, managed via Terraform Cloud.

---

## Overview

The infrastructure consists of multiple modules:

- **Networking:** Virtual Network (VNet), Subnets, DNS Private Zones
- **Compute:** Azure App Service with system-assigned and user-assigned managed identities
- **Database:** Azure Database for PostgreSQL Flexible Server
- **Key Vault:** Azure Key Vault with Private Endpoint for secure secrets management
- **Monitoring:** Application Insights and Azure Monitor for observability
- **Front Door:** Azure Front Door for global HTTP(s) load balancing and WAF

Terraform Cloud workspaces are used to separate environments (`dev` and `prod`) and manage variables securely.

---

## Environment Differentiation: `dev` vs `prod`

| Feature                       | Development (`dev`)                                                                                      | Production (`prod`)                                                                                                   |
| ----------------------------- | -------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| **Terraform Cloud Workspace** | `simple-cloud-dev`                                                                                       | `simple-cloud-prod`                                                                                                   |
| **App Service SKU**           | Lower-cost tier (e.g., `B1`)                                                                             | Production-grade tier (e.g., `P1v3`)                                                                                  |
| **Database SKU**              | Smaller, cost-effective (e.g., `GP_Standard_D2s_v3`)                                                     | Larger, high throughput (e.g., `GP_Gen5_4`)                                                                           |
| **Scaling & Redundancy**      | Minimal (single instance)                                                                                | Multiple instances, high availability                                                                                 |
| **Security Policies**         | Basic, allowing faster iteration                                                                         | Strict, with firewall, logging, and alerts                                                                            |
| **Azure Key Vault**           | Used for secrets management with relaxed access policies for easier dev workflow. Contains demo secrets. | Used for secrets with strict access control, audit logging, and production secrets. Private Endpoint enabled in both. |
| **Secrets Management**        | Demo or simplified secrets stored and rotated less frequently                                            | Production secrets with regular rotation and strict RBAC policies                                                     |
| **Monitoring & Alerts**       | Basic Application Insights setup                                                                         | Full monitoring, alerts, diagnostics enabled                                                                          |
| **Access Method**             | Direct access to resources via VPN or public endpoints                                                   | Private endpoints only, restricted network access                                                                     |

---

## Using Terraform Cloud

This infrastructure is deployed and managed via **Terraform Cloud**. All environment variables and secrets are configured in the respective Terraform Cloud workspace:

- Variables (e.g., subscription ID, resource group names, App Service names, SKUs, etc.) are set as **workspace variables**.
- Sensitive data such as client secrets, database passwords, and Key Vault secrets are stored in Terraform Cloud as **environment variables or sensitive variables**.
- Terraform Cloud manages state securely, enabling collaboration and version control for infrastructure.

**Note:** Do not store any sensitive credentials directly in the codebase or local environment files.

---

## Prerequisites

- Terraform CLI installed (v1.3+ recommended)
- Access to Terraform Cloud account with configured workspace(s)
- Azure CLI configured with appropriate permissions
- Properly configured service principal with Contributor or Owner role
- Azure subscription ready for resource deployment

---

## How to Deploy

1. Clone this repository locally:
   ```bash
   git clone https://github.com/kacperjarocki/simple-cloud.git
   cd simple-cloud
   Log in to Terraform Cloud and select the desired workspace (dev or prod).
   ```

Set or verify the workspace variables in Terraform Cloud UI or CLI:

Azure credentials (Client ID, Client Secret, Tenant ID, Subscription ID)

Resource names and configurations specific to the environment

Secrets or references to Azure Key Vault secrets

Run Terraform Cloud runs via the UI or API — Terraform Cloud will handle terraform init, plan, and apply automatically based on the workspace configuration.

Project Structure
.
├── modules/
│ ├── networking/
│ ├── compute/
│ ├── database/
│ ├── keyvault/
│ ├── monitoring/
│ └── frontdoor/
├── environments/
│ ├── dev/
│ └── prod/
├── main.tf
├── variables.tf
└── outputs.tf

modules/ - contains reusable Terraform modules for each resource type.

main.tf - root configuration which calls modules and sets environment.

Notes on Key Vault Usage
Both dev and prod environments use Azure Key Vault to securely manage secrets such as database credentials, App Service identities, and API keys.

Key Vault is configured with Private Endpoints in both environments to restrict network access.

Access policies in dev are more permissive to allow easier testing and development workflows.

In prod, access is tightly controlled with RBAC, auditing enabled, and secrets are rotated regularly.

The App Service in both environments has managed identities assigned for seamless access to Key Vault without embedding secrets in code or configuration.

Monitoring & Logging
Basic Application Insights integration is enabled in dev for easy diagnostics.

Production environment includes full Azure Monitor setup with alerts, dashboards, and diagnostic logs configured for SLA and compliance.

Troubleshooting & Support
If you encounter any issues during deployment:

Verify your Terraform Cloud workspace variables and secrets are correctly set.

Ensure Azure service principal has sufficient permissions.

Check Azure portal for resource health and activity logs.
