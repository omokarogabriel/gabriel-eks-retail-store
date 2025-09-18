# Gabriel Retail Store Infrastructure

This repository contains the infrastructure-as-code and deployment automation for the Gabriel Retail Store microservices platform. It uses **Terraform** for cloud resource provisioning and **Helm** for Kubernetes application deployment, orchestrated via **GitHub Actions**.

---

## Prerequisites

- **AWS Account** with permissions to create VPCs, EKS, RDS, DynamoDB, ElastiCache, IAM, and Secrets Manager resources.
- **kubectl** installed locally for cluster management.
- **Terraform** v1.3+ installed.
- **Node.js** v18+ for application builds and tests.
- **Helm** v3+ for Kubernetes deployments.
- **yq** for YAML manipulation in CI/CD.
- **GitHub Actions** secrets configured:
  - `KUBECONFIG_DEV`, `KUBECONFIG_STAGING`, `KUBECONFIG_PROD`
  - `KUBE_NAMESPACE_DEV`, `KUBE_NAMESPACE_STAGING`, `KUBE_NAMESPACE_PROD`


---

## Project Structure

```
gabriel_retail_store/
├── .github/workflows/deploy.yaml         # CI/CD workflow
├── environments/
│   └── dev/
│       ├── main.tf                       # Terraform root module for dev
│       ├── variables.tf                  # Terraform variables for dev
│       └── terraform.tfvars              # Dev environment values
├── modules/
│   ├── infrastructure/
│   │   ├── networking/                   # VPC, subnets
│   │   ├── security-group/               # Security groups
│   │   ├── iam/                          # IAM roles and policies
│   │   ├── eks_cluster/                  # EKS cluster
│   │   ├── rds/                          # RDS (Postgres, MySQL)
│   │   ├── dynamoDB/                     # DynamoDB
│   │   ├── elasticache/                  # Redis (ElastiCache)
│   │   ├── secrets/                      # Secrets Manager
│   │   ├── ingress_alb/                  # Application Load Balancer
│   │   ├── namespace_helm_release/       # Helm namespace setup
│   ├── application/
│   │   ├── retail_app/                   # Retail microservices
│   │   └── monitoring_logging/           # Monitoring and logging
├── helm/
│   ├── cart/
│   ├── catalog/
│   ├── checkout/
│   ├── order/
│   └── ui/
└── README.md
```

---

## What Is Created

### **Networking**
- VPC with public and private subnets.
- Security groups for RDS, EKS, ElastiCache, and application access.

### **IAM**
- Service account roles for Kubernetes workloads.
- IAM roles for Terraform and CI/CD.

### **Kubernetes**
- EKS cluster for running microservices.
- Namespace and service account setup via Helm.

### **Databases**
- **RDS PostgreSQL** and **RDS MySQL** instances with subnet groups and security.
- **DynamoDB** table for NoSQL storage.

### **Caching**
- **ElastiCache Redis** cluster (with optional password protection).

### **Secrets**
- AWS Secrets Manager for storing database and Redis passwords.

### **Ingress**
- Application Load Balancer for external access to services.

### **Application Deployment**
- Microservices deployed via Helm charts:
  - Cart, Catalog, Checkout, Order, UI
- Monitoring and logging stack.

---

## How to Deploy

### 1. **Configure Secrets**
Add the following secrets in your GitHub repository:
- `KUBECONFIG_DEV`, `KUBECONFIG_STAGING`, `KUBECONFIG_PROD`
- `KUBE_NAMESPACE_DEV`, `KUBE_NAMESPACE_STAGING`, `KUBE_NAMESPACE_PROD`
- Database and Redis passwords (if using password protection)

### 2. **Update Environment Variables**
Edit `environments/dev/terraform.tfvars` (and similar files for other environments) with your values.

### 3. **Run the Workflow**
- **Manual Trigger:**  
  Go to GitHub Actions, select `Build, Test, and Deploy`, and choose your environment (`dev`, `staging`, `prod`).
- **Automatic Trigger:**  
  Push or pull request to `main` branch triggers deployment to `dev`.

### 4. **Terraform Provisioning**
The workflow runs Terraform to provision all cloud resources.

### 5. **Helm Deployment**
After infrastructure is ready, Helm deploys all microservices to the EKS cluster.

---

## Environment Flexibility

- All environment-specific values are managed via `terraform.tfvars` and workflow inputs.
- The workflow automatically selects the correct kubeconfig and namespace for each environment.

---

## Notes

- **Redis Password:**  
  By default, ElastiCache Redis does not require a password.  
  If you want password protection, set `auth_token` in your Terraform module and pass the password to your Helm charts.
- **Secrets Management:**  
  Database and Redis passwords are stored in AWS Secrets Manager and referenced in Terraform and Helm.

---

## Troubleshooting

- Check GitHub Actions logs for errors.
- Ensure all required secrets are set in your repository.
- Verify AWS resource quotas and permissions.

---

## License

MIT