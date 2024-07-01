#  Working with Multiple Workspaces on AWS  #

## Introduction

In this advanced practice, you will learn how to work with multiple Terraform workspaces on AWS. Terraform workspaces allow you to manage different environments (such as development, test, and production) within the same Terraform configuration.

## Prerequisites

1. **AWS Account**: Ensure you have an AWS account with appropriate permissions to create and manage resources.
2. **AWS CLI**: Install and configure the AWS CLI with your AWS credentials.
3. **Terraform**: Install Terraform on your local machine.

## Section 1: Working with Multiple Terraform Workspaces on AWS

### Step 1: Initial Configuration

1. **Install Terraform**: Make sure you have Terraform installed. You can download it [here](https://www.terraform.io/downloads.html).
2. **Configure AWS CLI**: Ensure that the AWS CLI is configured correctly with the appropriate credentials.
3. **Create a Working Directory**: Create a new directory for your Terraform project.

    ```sh
    mkdir terraform-multiple-workspaces
    cd terraform-multiple-workspaces
    ```

### Step 2: Define Terraform Configuration

1. **Create a main configuration file (`main.tf`)**:

    ```hcl
    provider "aws" {
      region = "us-east-1"
    }

    # Define different values depending on the workspace
    locals {
      environment   = terraform.workspace
      bucket_name   = terraform.workspace == "prod" ? "prod-example-bucket" : "dev-example-bucket"
      instance_type = terraform.workspace == "prod" ? "t2.small" : "t2.micro"
    }

    resource "aws_instance" "example" {
      ami           = "ami-01b799c439fd5516a"  # Amazon Linux 2 AMI
      instance_type = local.instance_type

      tags = {
        Name        = "${local.environment}-example-instance"
        Environment = local.environment
      }
    }
    ```

2. **Initialize Terraform**:

    ```sh
    terraform init
    ```

### Step 3: Create and Switch Between Workspaces

1. **List Available Workspaces**:

    ```sh
    terraform workspace list
    ```

2. **Create New Workspaces**:

    ```sh
    terraform workspace new dev
    terraform workspace new prod
    ```

3. **Switch to an Existing Workspace**:

    ```sh
    terraform workspace select default
    ```

### Step 4: Deploy Resources in Different Workspaces

1. **Select and Deploy Resources in the `dev` Workspace**:

    ```sh
    terraform workspace select dev
    terraform apply -auto-approve
    ```

    - **Verify Resources in AWS Console**: Navigate to the AWS console and verify that an EC2 t2.micro instance has been created.

2. **Apply Settings in the `prod` Workspace**:

    ```sh
    terraform workspace select prod
    terraform apply -auto-approve
    ```

    - **Verify Resources in AWS Console**: Verify that an EC2 t2.small instance has been created.

### Step 5: Manage Workspaces

1. **Rename a Workspace**:

    ```sh
    terraform workspace select dev
    terraform workspace new staging
    terraform workspace delete dev
    ```

2. **Delete a Workspace** (Note: You cannot delete the current workspace):

    ```sh
    terraform workspace select default
    terraform workspace delete staging
    ```

### Step 6: Resource Cleanup

1. **Destroy Resources in a Workspace**:

    ```sh
    terraform workspace select prod
    terraform destroy -auto-approve
    ```

2. **Delete All Workspaces**:

    ```sh
    terraform workspace select default
    terraform workspace delete prod
    terraform workspace delete dev
    ```

## Resource Tags

- **Label Name**:
  - In the `prod` workspace: `prod-example-instance`
  - In the `dev` workspace: `dev-example-instance`
- **Environment Label**:
  - In both workspaces (`prod` and `dev`): The value is the name of the workspace (i.e., `prod` or `dev`).

## Final Exercise

1. **Challenge**: Extend the Terraform configuration to include an RDS database in each workspace with different sizes depending on the environment (`prod` and `dev`).

2. **Objective**: Practice creating and managing more complex resources in multiple workspaces.

---

This README guides you through the process of setting up multiple Terraform workspaces, deploying resources in those workspaces, and managing the workspaces effectively. Follow the steps outlined to ensure a smooth setup and deployment process.
