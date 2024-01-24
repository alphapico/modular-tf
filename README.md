# Modular Terraform Infrastructure

This repository contains the Terraform code for setting up the infrastructure of project. It includes configurations for AWS services like Elastic Container Registry (ECR), Virtual Private Cloud (VPC), Elastic Beanstalk, Relational Database Service (RDS), and Simple Storage Service (S3).

## Overview

The infrastructure is organized into several modules, each responsible for a specific part of the AWS setup:

- **ECR Module**: Manages the Elastic Container Registry for Docker images.
- **Network Module**: Sets up the VPC, subnets, and availability zones.
- **Beanstalk Module**: Configures the Elastic Beanstalk environment for application deployment.
- **RDS Module**: Handles the setup for the RDS PostgreSQL database.
- **S3 Module**: Manages S3 buckets for object storage.

## Configuration

Before running Terraform, you need to configure your variables in the `terraform.tfvars` file. Here's a template for the file:

```bash
# Network configuration
vpc_cidr_block      = "10.0.0.0/16"
subnet_cidr_block_1 = "10.0.10.0/24"
subnet_cidr_block_2 = "10.0.2.0/24"
avail_zone_1        = "eu-central-1a" # Choose your availability zone
avail_zone_2        = "eu-central-1b" # Choose another availability zone

# General settings
region      = "eu-central-1" # AWS region
env_prefix  = "dev"          # Environment prefix, e.g., 'dev', 'prod'
app_name    = ""             # Application name
bucket_name = ""             # S3 bucket name

# Database configuration
db_name           = ""             # Database name
db_username       = ""             # Database username
db_password       = ""             # Database password
allocated_storage = 20             # Allocated storage in GB
instance_class    = "db.t2.micro"  # RDS instance class
postgres_port     = 5432           # PostgreSQL port

# Application configuration
app_port      = 8080          # Application port
docker_img_tag = ""           # Docker image tag
jwt_secret    = ""            # JWT secret key
frontend_domain = ""          # Frontend domain
email_name    = ""            # Email sender name
email_from    = ""            # Email sender address

# Admin user configuration
admin_email             = "" # Admin email address
admin_initial_password  = "" # Admin initial password
```

## Run the command

```bash
terraform init

terraform plan -var-file terraform.tfvars
terraform apply -var-file terraform.tfvars
```
