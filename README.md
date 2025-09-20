# Gabriel Retail Store Infrastructure

This repository contains the infrastructure-as-code and deployment automation for the Gabriel Retail Store microservices platform. It uses **Terraform** for cloud resource provisioning and **Helm** for Kubernetes application deployment, orchestrated via **GitHub Actions**.

---

## Prerequisites

### **🔧 Required Tools**
- **AWS CLI** v2+ configured with valid credentials
- **Terraform** v1.3+ installed
- **kubectl** installed locally for cluster management
- **Node.js** v18+ for application builds and tests
- **Helm** v3+ for Kubernetes deployments
- **yq** for YAML manipulation in CI/CD

### **☁️ AWS Requirements**
- **AWS Account** with administrative permissions
- **AWS Credentials** configured via one of:
  - `aws configure` (recommended for local development)
  - Environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
  - IAM roles (for EC2/Lambda execution)
  - AWS CLI profiles

### **🔐 Required AWS Permissions**
Your AWS user/role must have permissions for:
- **VPC & Networking**: `AmazonVPCFullAccess`
- **EKS**: `AmazonEKSClusterPolicy`, EKS management permissions
- **RDS**: `AmazonRDSFullAccess`
- **DynamoDB**: `AmazonDynamoDBFullAccess`
- **ElastiCache**: `AmazonElastiCacheFullAccess`
- **Secrets Manager**: `SecretsManagerReadWrite`
- **IAM**: `IAMFullAccess` (for creating service roles)
- **EC2**: Instance and security group management

### **🚀 GitHub Actions Configuration**
This project uses **OIDC (OpenID Connect)** for secure, credential-free AWS authentication.

**Required GitHub Secrets:**
- `AWS_ROLE_ARN_DEV`, `AWS_ROLE_ARN_STAGING`, `AWS_ROLE_ARN_PROD` - IAM role ARNs for OIDC
- `KUBECONFIG_DEV`, `KUBECONFIG_STAGING`, `KUBECONFIG_PROD` - Kubernetes configurations
- `KUBE_NAMESPACE_DEV`, `KUBE_NAMESPACE_STAGING`, `KUBE_NAMESPACE_PROD` - K8s namespaces

---

## Project Structure

```
gabriel_retail_store/
├── .github/workflows/
│   ├── deploy.yaml                       # CI/CD deployment workflow
│   └── destroy.yaml                      # Infrastructure destruction workflow
├── environments/
│   └── dev/
│       ├── main.tf                       # Terraform root module for dev
│       ├── variables.tf                  # Terraform variables for dev
│       ├── terraform.tfvars              # Dev environment values
│       └── output.tf                     # Terraform outputs
├── modules/
│   ├── infrastructure/
│   │   ├── networking/                   # VPC, subnets, routing
│   │   ├── security-group/               # Security groups
│   │   ├── iam/                          # IAM roles and policies
│   │   ├── eks_cluster/                  # EKS cluster and node groups
│   │   ├── rds/                          # RDS (PostgreSQL, MySQL)
│   │   ├── dynamoDB/                     # DynamoDB tables
│   │   ├── elasticache/                  # Redis (ElastiCache)
│   │   ├── secrets/                      # AWS Secrets Manager
│   │   ├── ingress_alb/                  # Application Load Balancer
│   │   └── namespace_helm_release/       # Kubernetes namespace setup
│   └── application/
│       ├── retail_app/                   # Retail microservices
│       └── monitoring_logging/           # Observability stack
├── helm/
│   ├── cart/                            # Shopping cart service
│   ├── catalog/                         # Product catalog service
│   ├── checkout/                        # Checkout processing service
│   ├── order/                           # Order management service
│   └── ui/                              # Frontend web application
└── README.md
```

```
.
├── environments
│   ├── dev
│   │   ├── backend.tf
│   │   ├── dev
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── prod
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── terraform.tfvars
│   └── staging
│       ├── backend.tf
│       ├── main.tf
│       ├── output.tf
│       └── terraform.tfvars
├── helm
│   ├── cart
│   │   └── values.yaml
│   ├── catalog
│   │   └── values.yaml
│   ├── checkout
│   │   └── values.yaml
│   ├── common
│   │   ├── Chart.yaml
│   │   ├── templates
│   │   │   ├── deployment.yaml
│   │   │   ├── ingress.yaml
│   │   │   └── service.yaml
│   │   └── values.yaml
│   ├── order
│   │   └── values.yaml
│   └── ui
│       └── values.yaml
├── modules
│   ├── application
│   │   ├── monitoring_logging
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variable.tf
│   │   └── retail_app
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variable.tf
│   └── infrastructure
│       ├── dynamoDB
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── eks_cluster
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── elasticache
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── iam
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── ingress_alb
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── namespace_helm_release
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── networking
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── rds
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── secrets
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       └── security-group
│           ├── main.tf
│           ├── output.tf
│           └── variable.tf
├── provider
│   ├── main.tf
│   ├── output.tf
│   └── variable.tf
└── README.md
```

```
.
├── environments
│   ├── dev
│   │   ├── backend.tf
│   │   ├── dev
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── prod
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── terraform.tfvars
│   └── staging
│       ├── backend.tf
│       ├── main.tf
│       ├── output.tf
│       └── terraform.tfvars
├── environments
│   ├── dev
│   │   ├── backend.tf
│   │   ├── dev
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── .terraform
│   │   │   ├── modules
│   │   │   │   └── modules.json
│   │   │   └── providers
│   │   │       └── registry.terraform.io
│   │   │           └── hashicorp
│   │   │               ├── aws
│   │   │               │   └── 6.14.0
│   │   │               │       └── linux_amd64
│   │   │               │           ├── LICENSE.txt
│   │   │               │           └── terraform-provider-aws_v6.14.0_x5
│   │   │               ├── kubernetes
│   │   │               │   └── 2.38.0
│   │   │               │       └── linux_amd64
│   │   │               │           ├── LICENSE.txt
│   │   │               │           └── terraform-provider-kubernetes_v2.38.0_x5
│   │   │               └── tls
│   │   │                   └── 4.1.0
│   │   │                       └── linux_amd64
│   │   │                           ├── LICENSE.txt
│   │   │                           └── terraform-provider-tls_v4.1.0_x5
│   │   ├── .terraform.lock.hcl
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   ├── prod
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── terraform.tfvars
│   └── staging
│       ├── backend.tf
│       ├── main.tf
│       ├── output.tf
│       └── terraform.tfvars
├── .github
│   └── workflows
│       ├── deploy.yaml
│       └── destroy.yaml
├── .gitignore
├── helm
│   ├── cart
│   │   └── values.yaml
│   ├── catalog
│   │   └── values.yaml
│   ├── checkout
│   │   └── values.yaml
│   ├── common
│   │   ├── Chart.yaml
│   │   ├── templates
│   │   │   ├── deployment.yaml
│   │   │   ├── ingress.yaml
│   │   │   └── service.yaml
│   │   └── values.yaml
│   ├── order
│   │   └── values.yaml
│   └── ui
│       └── values.yaml
├── modules
│   ├── application
│   │   ├── monitoring_logging
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── variable.tf
│   │   └── retail_app
│   │       ├── main.tf
│   │       ├── output.tf
│   │       └── variable.tf
│   └── infrastructure
│       ├── dynamoDB
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── eks_cluster
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── elasticache
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── iam
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── ingress_alb
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── namespace_helm_release
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── networking
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── rds
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       ├── secrets
│       │   ├── main.tf
│       │   ├── output.tf
│       │   └── variable.tf
│       └── security-group
│           ├── main.tf
│           ├── output.tf
│           └── variable.tf
├── provider
│   ├── main.tf
│   ├── output.tf
│   └── variable.tf
└── README.md
```


---

## AWS Resources Created (Comprehensive)

### **🌐 Networking Infrastructure**

#### **VPC (Virtual Private Cloud)**
- **Resource**: `aws_vpc.retail_vpc`
- **Purpose**: Isolated network environment for all resources
- **Configuration**:
  - CIDR Block: `10.0.0.0/16` (65,536 IP addresses)
  - DNS Support: Enabled
  - DNS Hostnames: Enabled
- **Use Case**: Foundation for all networking components, provides network isolation

#### **Internet Gateway**
- **Resource**: `aws_internet_gateway.igw`
- **Purpose**: Provides internet connectivity to public subnets
- **Attached To**: VPC
- **Use Case**: Enables outbound internet access for NAT Gateway and public-facing resources

#### **NAT Gateway**
- **Resource**: `aws_nat_gateway.nat`
- **Purpose**: Enables private subnet resources to access internet for updates/patches
- **Configuration**:
  - Placement: Public subnet
  - Elastic IP: Attached for consistent outbound IP
- **Use Case**: EKS nodes, RDS, ElastiCache internet access without exposing them publicly

#### **Elastic IP**
- **Resource**: `aws_eip.nat`
- **Purpose**: Static IP address for NAT Gateway
- **Domain**: VPC
- **Use Case**: Consistent outbound IP for private resources, whitelisting external services

#### **Subnets**

**Public Subnets**:
- **Resource**: `aws_subnet.public`
- **CIDR**: `10.0.1.0/24` (256 IP addresses)
- **Purpose**: Internet-facing resources
- **Configuration**:
  - Auto-assign Public IP: Enabled
  - Availability Zone: Multi-AZ deployment
- **Tags**: `kubernetes.io/role/elb = 1` (ALB placement)
- **Use Case**: NAT Gateway, Application Load Balancers, bastion hosts

**Private Subnets**:
- **Resource**: `aws_subnet.private`
- **CIDR**: `10.0.2.0/24` (256 IP addresses)
- **Purpose**: Internal resources without direct internet access
- **Configuration**:
  - No public IP assignment
  - Availability Zone: Multi-AZ deployment
- **Tags**: `kubernetes.io/role/internal-elb = 1` (NLB placement)
- **Use Case**: EKS nodes, RDS instances, ElastiCache clusters

#### **Route Tables**

**Public Route Table**:
- **Resource**: `aws_route_table.public`
- **Routes**: `0.0.0.0/0` → Internet Gateway
- **Purpose**: Direct internet routing for public subnets
- **Use Case**: Internet access for public resources

**Private Route Table**:
- **Resource**: `aws_route_table.private`
- **Routes**: `0.0.0.0/0` → NAT Gateway
- **Purpose**: Internet access via NAT for private subnets
- **Use Case**: Secure internet access for private resources

#### **Route Table Associations**
- **Resources**: `aws_route_table_association.public/private`
- **Purpose**: Links subnets to appropriate route tables
- **Effect**: Determines traffic routing behavior for each subnet

---

### **🔒 Security Groups (Network Access Control)**

#### **EKS Nodes Security Group**
- **Resource**: `aws_security_group.eks_nodes_sg`
- **Purpose**: Controls network traffic to/from EKS worker nodes
- **Ingress Rules**:
  - **Self-referencing**: All ports (0-65535) TCP
    - **Purpose**: Node-to-node communication, pod networking
  - **Control Plane Communication**: Ports 1025-65535 TCP from VPC CIDR
    - **Purpose**: Kubelet and pod communication with control plane
  - **API Extensions**: Port 443 TCP from VPC CIDR
    - **Purpose**: Extension API servers communication
- **Egress Rules**: All traffic to `0.0.0.0/0`
  - **Purpose**: Internet access for container image pulls, updates
- **Use Case**: Secure EKS cluster networking, inter-pod communication

#### **RDS Security Group**
- **Resource**: `aws_security_group.rds_sg`
- **Purpose**: Database access control - restricts database access to authorized sources
- **Ingress Rules**:
  - **MySQL**: Port 3306 TCP from EKS nodes security group only
    - **Purpose**: MySQL database access from application pods
  - **PostgreSQL**: Port 5432 TCP from EKS nodes security group only
    - **Purpose**: PostgreSQL database access from application pods
- **Egress Rules**: All traffic to `0.0.0.0/0`
  - **Purpose**: Database maintenance, updates, replication
- **Use Case**: Restrict database access to only authorized EKS applications

#### **ElastiCache Security Group**
- **Resource**: `aws_security_group.elasticache_sg`
- **Purpose**: Redis cache access control
- **Ingress Rules**:
  - **Redis**: Port 6379 TCP from EKS nodes security group only
    - **Purpose**: Redis access from application pods for caching/sessions
- **Egress Rules**: All traffic to `0.0.0.0/0`
  - **Purpose**: Maintenance and monitoring
- **Use Case**: Secure Redis access from applications only, prevent unauthorized access

---

### **👤 IAM Roles & Policies (Comprehensive)**

#### **EKS Cluster Service Role**
- **Resource**: `aws_iam_role.eks_cluster_role`
- **Purpose**: Allows EKS service to manage cluster resources on your behalf
- **Trust Policy**: 
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "eks.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }
  ```
- **Attached AWS Managed Policies**:
  - `AmazonEKSClusterPolicy` - Core EKS cluster management permissions
- **Specific Permissions Include**:
  - Create/manage ENIs for cluster networking
  - Manage cluster lifecycle (create, update, delete)
  - CloudWatch logging integration
  - VPC resource management for cluster
  - Security group management for cluster
- **Use Case**: EKS control plane operations, cluster management

#### **EKS Node Group Service Role**
- **Resource**: `aws_iam_role.eks_node_role`
- **Purpose**: Allows EC2 instances to join EKS cluster as worker nodes
- **Trust Policy**:
  ```json
  {
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }
  ```
- **Attached AWS Managed Policies**:
  - `AmazonEKSWorkerNodePolicy` - Node registration and management
  - `AmazonEKS_CNI_Policy` - VPC CNI plugin for pod networking
  - `AmazonEC2ContainerRegistryReadOnly` - Pull container images from ECR
- **Specific Permissions Include**:
  - EC2 instance management and metadata access
  - ENI creation/attachment for pod networking
  - ECR image pulling and authentication
  - CloudWatch metrics and logs publishing
  - Auto Scaling group management
- **Use Case**: Worker node operations, pod networking, container runtime

#### **OIDC Identity Providers**

**EKS OIDC Provider**:
- **Resource**: `aws_iam_openid_connect_provider.eks_oidc`
- **Purpose**: Enables IAM roles for Kubernetes service accounts (IRSA)
- **Configuration**:
  - **URL**: EKS cluster OIDC issuer URL
  - **Client ID**: `sts.amazonaws.com`
  - **Thumbprint**: TLS certificate fingerprint from EKS cluster
- **Use Case**: Secure pod-to-AWS service authentication without storing credentials

**GitHub Actions OIDC Provider**:
- **Resource**: `aws_iam_openid_connect_provider.github_actions`
- **Purpose**: Enables GitHub Actions to assume AWS roles without long-lived credentials
- **Configuration**:
  - **URL**: `https://token.actions.githubusercontent.com`
  - **Client ID**: `sts.amazonaws.com`
  - **Thumbprint**: `6938fd4d98bab03faadb97b34396831e3780aea1`
- **Use Case**: Secure CI/CD authentication, credential-free deployments

#### **Service Account IAM Role**
- **Resource**: `aws_iam_role.sa_role`
- **Purpose**: Custom role for specific Kubernetes service accounts
- **Trust Policy**: EKS OIDC provider with namespace/service account conditions
- **Condition**: 
  ```json
  {
    "StringEquals": {
      "oidc.eks.region.amazonaws.com/id/CLUSTER_ID:sub": "system:serviceaccount:NAMESPACE:SERVICE_ACCOUNT"
    }
  }
  ```
- **Use Case**: Application-specific AWS permissions (S3 access, DynamoDB operations, etc.)

#### **AWS Load Balancer Controller IAM Role**
- **Resource**: `aws_iam_role.aws_load_balancer_controller`
- **Purpose**: Manages AWS load balancers from Kubernetes ingress resources
- **Trust Policy**: EKS OIDC provider for `kube-system:aws-load-balancer-controller`
- **Custom Policy Permissions**:
  - **EC2 Permissions**:
    - `DescribeAccountAttributes`, `DescribeAddresses`, `DescribeAvailabilityZones`
    - `DescribeInternetGateways`, `DescribeVpcs`, `DescribeSubnets`
    - `DescribeSecurityGroups`, `DescribeInstances`, `DescribeNetworkInterfaces`
    - `CreateSecurityGroup`, `CreateTags`, `AuthorizeSecurityGroupIngress`
  - **ELB Permissions**:
    - `CreateLoadBalancer`, `CreateTargetGroup`, `CreateListener`
    - `ModifyLoadBalancerAttributes`, `ModifyTargetGroup`
    - `DeleteLoadBalancer`, `DeleteTargetGroup`, `DeleteListener`
    - `RegisterTargets`, `DeregisterTargets`
  - **ACM Permissions**: `ListCertificates`, `DescribeCertificate`
  - **WAF Permissions**: `GetWebACL`, `AssociateWebACL`, `DisassociateWebACL`
  - **Shield Permissions**: `DescribeProtection`, `CreateProtection`
  - **IAM Permissions**: `CreateServiceLinkedRole`
- **Use Case**: Automatic ALB/NLB provisioning and management for Kubernetes ingress

#### **GitHub Actions IAM Role**
- **Resource**: `aws_iam_role.github_actions`
- **Purpose**: Comprehensive permissions for CI/CD infrastructure operations
- **Trust Policy**: GitHub OIDC provider with repository-specific conditions
- **Repository Condition**: 
  ```json
  {
    "StringLike": {
      "token.actions.githubusercontent.com:sub": "repo:YOUR_GITHUB_USERNAME/gabriel_retail_store:*"
    }
  }
  ```
- **Policy Permissions** (Full Access):
  - **EC2**: VPC, security groups, instances, networking
  - **EKS**: Cluster and node group management
  - **RDS**: Database instance lifecycle management
  - **DynamoDB**: Table operations and management
  - **ElastiCache**: Cluster management
  - **Secrets Manager**: Secret creation, rotation, and management
  - **IAM**: Role and policy management for infrastructure
  - **STS**: Token operations and role assumption
- **Use Case**: Terraform infrastructure deployment, updates, and destruction

---

### **☸️ Kubernetes Infrastructure (Detailed)**

#### **EKS Cluster**
- **Resource**: `aws_eks_cluster.retail_eks`
- **Configuration**:
  - **Version**: 1.28 (latest stable)
  - **Service Role**: EKS cluster service role
  - **VPC Configuration**:
    - **Subnets**: Both public and private subnets for flexibility
    - **Endpoint Private Access**: Enabled (cluster API accessible from VPC)
    - **Endpoint Public Access**: Enabled (cluster API accessible from internet)
    - **Public Access CIDRs**: `0.0.0.0/0` (can be restricted for security)
  - **Logging**: Comprehensive logging enabled
    - **API**: API server logs
    - **Audit**: Kubernetes audit logs
    - **Authenticator**: Authentication logs
    - **ControllerManager**: Controller manager logs
    - **Scheduler**: Scheduler logs
- **Use Case**: Managed Kubernetes control plane, API server, etcd

#### **EKS Node Group**
- **Resource**: `aws_eks_node_group.retail_nodes`
- **Configuration**:
  - **Instance Types**: `t3.medium` (2 vCPU, 4 GB RAM)
  - **Capacity Type**: ON_DEMAND (predictable pricing)
  - **Scaling Configuration**:
    - **Desired Capacity**: 2 nodes
    - **Minimum Capacity**: 1 node
    - **Maximum Capacity**: 4 nodes
  - **Update Configuration**: 
    - **Max Unavailable**: 1 (rolling updates)
  - **Subnet Placement**: Private subnets only (security)
  - **Service Role**: EKS node group service role
- **Use Case**: Worker nodes for running application pods, auto-scaling based on demand

---

### **🗄️ Database Services (Comprehensive)**

#### **RDS PostgreSQL Instance**
- **Resource**: `aws_db_instance.postgres`
- **Configuration**:
  - **Engine**: PostgreSQL 15.3 (latest stable)
  - **Instance Class**: `db.t3.medium` (2 vCPU, 4 GB RAM)
  - **Storage**: 
    - **Initial**: 20GB GP2 SSD
    - **Auto-scaling**: Up to 100GB
    - **Encryption**: Enabled
  - **Database**: `retail` (application database)
  - **High Availability**: Multi-AZ deployment enabled
  - **Backup Configuration**:
    - **Retention**: 7 days
    - **Window**: 03:00-04:00 UTC
  - **Maintenance Window**: Sunday 04:00-05:00 UTC
  - **Network Security**: 
    - **Subnets**: Private subnets only
    - **Security Group**: RDS security group
  - **Authentication**: Password retrieved from AWS Secrets Manager
- **Use Case**: Primary relational database for order management, user data, transactions

#### **RDS MySQL Instance**
- **Resource**: `aws_db_instance.mysql`
- **Configuration**:
  - **Engine**: MySQL 8.0 (latest stable)
  - **Instance Class**: `db.t3.micro` (1 vCPU, 1 GB RAM)
  - **Storage**: 
    - **Initial**: 20GB GP2 SSD
    - **Auto-scaling**: Up to 100GB
    - **Encryption**: Enabled
  - **Database**: `retail` (application database)
  - **High Availability**: Multi-AZ deployment enabled
  - **Backup Configuration**:
    - **Retention**: 7 days
    - **Window**: 03:00-04:00 UTC
  - **Maintenance Window**: Sunday 04:00-05:00 UTC
  - **Network Security**: 
    - **Subnets**: Private subnets only
    - **Security Group**: RDS security group
  - **Authentication**: Password retrieved from AWS Secrets Manager
- **Use Case**: Secondary database for catalog, inventory, product information

#### **RDS Subnet Group**
- **Resource**: `aws_db_subnet_group.rds_subnet_group`
- **Purpose**: Defines subnet placement for RDS instances
- **Configuration**:
  - **Subnets**: All private subnets across multiple AZs
  - **Multi-AZ**: Ensures high availability
- **Use Case**: Ensures databases are deployed in private, secure subnets with AZ redundancy

#### **DynamoDB Table**
- **Resource**: `aws_dynamodb_table.dynamodb`
- **Configuration**:
  - **Billing Mode**: Pay-per-request (serverless scaling)
  - **Hash Key**: `dynamo_id` (String type)
  - **Encryption**: AWS managed keys (default)
  - **Point-in-time Recovery**: Available
- **Use Case**: High-performance NoSQL storage for shopping cart data, session storage, real-time features

---

### **⚡ Caching Layer (Detailed)**

#### **ElastiCache Redis Cluster**
- **Resource**: `aws_elasticache_cluster.redis`
- **Configuration**:
  - **Engine**: Redis (latest compatible version)
  - **Node Type**: `cache.t3.micro` (1 vCPU, 0.5 GB RAM)
  - **Cluster Mode**: Single node (can be upgraded to cluster mode)
  - **Port**: 6379 (standard Redis port)
  - **Network Security**: 
    - **Subnets**: Private subnets only
    - **Security Group**: ElastiCache security group
  - **Subnet Group**: Redis subnet group
  - **Backup**: Automatic snapshots available
- **Use Case**: Session storage, application caching, real-time data, pub/sub messaging

#### **ElastiCache Subnet Group**
- **Resource**: `aws_elasticache_subnet_group.redis_subnet_group`
- **Purpose**: Defines subnet placement for Redis cluster
- **Configuration**:
  - **Subnets**: All private subnets
  - **Multi-AZ**: Available for cluster mode
- **Use Case**: Ensures Redis is deployed securely in private subnets

---

### **🔐 Secrets Management (Comprehensive)**

#### **AWS Secrets Manager**

**PostgreSQL Password Secret**:
- **Resource**: `aws_secretsmanager_secret.postgres_password`
- **Configuration**:
  - **Name**: `{vpc_name}-postgres-password`
  - **Description**: PostgreSQL database master password
  - **Encryption**: AWS KMS managed keys
  - **Rotation**: Manual (can be automated)
- **Access Control**: IAM roles and policies
- **Use Case**: Secure storage and retrieval of PostgreSQL credentials

**MySQL Password Secret**:
- **Resource**: `aws_secretsmanager_secret.mysql_password`
- **Configuration**:
  - **Name**: `{vpc_name}-mysql-password`
  - **Description**: MySQL database master password
  - **Encryption**: AWS KMS managed keys
  - **Rotation**: Manual (can be automated)
- **Access Control**: IAM roles and policies
- **Use Case**: Secure storage and retrieval of MySQL credentials

#### **Secret Versions**
- **Resources**: `aws_secretsmanager_secret_version`
- **Purpose**: Store actual password values securely
- **Configuration**:
  - **Encryption**: AWS KMS managed keys
  - **Versioning**: Automatic version management
- **Use Case**: Secure password storage with version history

#### **Kubernetes External Secrets Integration**
- **Resources**: `kubernetes_manifest.external_secret_*`
- **Purpose**: Sync AWS Secrets Manager secrets to Kubernetes secrets
- **Configuration**:
  - **Refresh Interval**: 1 hour (configurable)
  - **Secret Store**: AWS Secrets Store (ClusterSecretStore)
  - **Target Secrets**: 
    - `app-postgres-db-secret`
    - `app-mysql-db-secret`
  - **Namespace**: Application namespace
- **Use Case**: Make AWS secrets available to pods as native Kubernetes secrets

---

### **🚀 Application Deployment (Detailed)**

#### **Kubernetes Namespace**
- **Management**: Helm-managed namespace creation
- **Purpose**: Logical isolation and organization of application resources
- **Configuration**: Environment-specific naming (dev, staging, prod)
- **Features**:
  - **Resource Quotas**: Can be applied for resource management
  - **Network Policies**: Can be applied for network segmentation
  - **RBAC**: Role-based access control boundaries
- **Use Case**: Multi-tenancy, resource organization, security boundaries

#### **Microservices Architecture**

**1. Cart Service**
- **Purpose**: Shopping cart management and operations
- **Database**: DynamoDB (high-performance, scalable)
- **Dependencies**: 
  - Redis for session storage
  - User authentication service
- **Endpoints**: Add/remove items, view cart, clear cart
- **Scaling**: Horizontal pod autoscaling based on CPU/memory

**2. Catalog Service**
- **Purpose**: Product catalog, inventory, and search
- **Database**: MySQL (relational data for products)
- **Dependencies**: 
  - Redis for search result caching
  - Image storage (S3 integration possible)
- **Endpoints**: Product search, category browsing, inventory checks
- **Scaling**: Horizontal pod autoscaling with read replicas

**3. Checkout Service**
- **Purpose**: Order processing, payment integration, order validation
- **Database**: Redis for temporary checkout data
- **Dependencies**: 
  - Cart service for cart data
  - Catalog service for product validation
  - Payment gateway integration
- **Endpoints**: Process checkout, validate payment, create orders
- **Scaling**: Vertical scaling for payment processing reliability

**4. Order Service**
- **Purpose**: Order management, history, and tracking
- **Database**: PostgreSQL (ACID compliance for orders)
- **Dependencies**: 
  - All other services for order fulfillment
  - Notification services
- **Endpoints**: Order history, order status, order updates
- **Scaling**: Horizontal scaling with database read replicas

**5. UI Service**
- **Purpose**: Frontend web application and user interface
- **Technology**: Web server serving static/dynamic content
- **Dependencies**: All backend microservices via API calls
- **Features**:
  - **Load Balancing**: Application Load Balancer integration
  - **SSL/TLS**: Certificate management via ACM
  - **CDN**: CloudFront integration possible
- **Scaling**: Horizontal pod autoscaling based on traffic

#### **AWS Load Balancer Controller**
- **Deployment**: Helm chart in `kube-system` namespace
- **Purpose**: Automatic AWS load balancer provisioning for Kubernetes ingress
- **Configuration**:
  - **Service Account**: `aws-load-balancer-controller`
  - **IAM Role**: AWS Load Balancer Controller role via IRSA
  - **Cluster Integration**: Environment-specific cluster name
- **Features**:
  - **ALB Integration**: Automatic Application Load Balancer creation
  - **NLB Integration**: Network Load Balancer support
  - **Target Group Management**: Automatic target registration
  - **Health Checks**: Kubernetes readiness/liveness probe integration
- **Use Case**: Expose services to internet with AWS-native load balancing

---

## How to Deploy

### 1. **Setup GitHub OIDC Authentication**

**Step 1: Deploy Infrastructure First**
```bash
# For initial setup, use AWS CLI locally
aws configure
cd environments/dev
terraform init
terraform apply
```

**Step 2: Get Role ARN**
```bash
# After Terraform deployment, get the GitHub Actions role ARN
terraform output github_actions_role_arn
```

**Step 3: Configure GitHub Secrets**
Add the role ARN to your repository secrets as `AWS_ROLE_ARN_DEV`

### 2. **Configure Additional Secrets**
Add the following secrets in your GitHub repository:
- `KUBECONFIG_DEV`, `KUBECONFIG_STAGING`, `KUBECONFIG_PROD`
- `KUBE_NAMESPACE_DEV`, `KUBE_NAMESPACE_STAGING`, `KUBE_NAMESPACE_PROD`

### 3. **Update Environment Variables**
Edit `environments/dev/terraform.tfvars` with your specific values:
```hcl
vpc_name              = "dev-vpc-retail-store"
environment           = "dev"
postgres_username     = "postgres_admin"
mysql_username        = "mysql_admin"
postgres_password     = "your_secure_postgres_password"
mysql_password        = "your_secure_mysql_password"
```

### 4. **Run the Workflow**
- **Manual Trigger**: GitHub Actions → "Build, Test, and Deploy" → Select environment
- **Automatic Trigger**: Push to `main` branch triggers dev deployment

### 5. **Infrastructure Provisioning**
Terraform creates all AWS resources in dependency order:
1. Networking (VPC, subnets, routing)
2. Security groups
3. IAM roles and policies
4. Secrets Manager
5. RDS databases
6. EKS cluster and nodes
7. DynamoDB and ElastiCache

### 6. **Application Deployment**
Helm deploys microservices to EKS cluster:
1. AWS Load Balancer Controller
2. External Secrets Operator
3. Application microservices
4. Ingress resources and load balancers

---

## Security Features

### **🔐 OIDC Authentication**
- **No Long-lived Credentials**: GitHub Actions uses temporary tokens
- **Automatic Token Rotation**: Tokens expire automatically
- **Fine-grained Permissions**: Role-based access control
- **Audit Trail**: All actions logged in CloudTrail
- **Secure by Default**: No credentials stored in repository

### **🛡️ Network Security**
- **Private Subnets**: Databases and applications isolated from internet
- **Security Groups**: Restrictive ingress rules, specific port access
- **NACLs**: Additional network-level security (can be added)
- **VPC Flow Logs**: Network traffic monitoring (can be enabled)

### **🔒 Data Security**
- **Encryption at Rest**: All databases and storage encrypted
- **Encryption in Transit**: TLS/SSL for all communications
- **Secrets Management**: AWS Secrets Manager for credential storage
- **IAM Roles**: No hardcoded credentials in applications

---

## Environment Flexibility

- **Multi-Environment Support**: Dev, staging, prod configurations
- **Environment-specific Variables**: Managed via `terraform.tfvars`
- **Workflow Flexibility**: Automatic environment selection
- **Resource Scaling**: Environment-appropriate instance sizes
- **Cost Optimization**: Smaller instances for dev, production-ready for prod

---

## Monitoring and Observability

### **CloudWatch Integration**
- **EKS Logging**: Control plane logs in CloudWatch
- **Application Logs**: Container logs via CloudWatch Logs
- **Metrics**: Custom and system metrics collection
- **Alarms**: Automated alerting for critical issues

### **Kubernetes Native**
- **Health Checks**: Readiness and liveness probes
- **Resource Monitoring**: CPU, memory, storage metrics
- **Event Logging**: Kubernetes events and audit logs

---

## Cost Optimization

### **Resource Sizing**
- **Development**: Smaller instance types (`t3.micro`, `t3.medium`)
- **Production**: Appropriately sized instances for workload
- **Auto Scaling**: Automatic scaling based on demand

### **Storage Optimization**
- **GP2 Storage**: Cost-effective SSD storage
- **Auto Scaling Storage**: Pay only for used storage
- **Backup Retention**: Configurable retention periods

### **Compute Optimization**
- **Spot Instances**: Can be configured for non-critical workloads
- **Reserved Instances**: Cost savings for predictable workloads
- **Right-sizing**: Regular review and optimization

---

## Disaster Recovery

### **Multi-AZ Deployment**
- **RDS**: Multi-AZ for automatic failover
- **EKS**: Nodes distributed across AZs
- **Subnets**: Resources spread across availability zones

### **Backup Strategy**
- **RDS Backups**: 7-day retention with point-in-time recovery
- **EKS**: Persistent volume snapshots
- **Configuration**: Infrastructure as Code for rapid rebuild

---

## Troubleshooting

### **Common Issues**
- **AWS Credentials**: Ensure proper OIDC configuration
- **Resource Limits**: Check AWS service quotas
- **Network Connectivity**: Verify security group rules
- **DNS Resolution**: Ensure VPC DNS settings are correct

### **Debugging Tools**
- **CloudWatch Logs**: Application and system logs
- **kubectl**: Kubernetes cluster debugging
- **AWS CLI**: Resource inspection and management
- **Terraform**: State inspection and planning

---

## License

MIT