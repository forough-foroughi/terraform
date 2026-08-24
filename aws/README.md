
This directory contains Terraform files for creating Amazon resources.

```
‍‍‍AWS
├── README.md
├── ec2/
├── 
```

# EC2
## Current Configuration

The configuration currently includes:

- An AWS provider using the `eu-central-1` region by default.
- An EC2 instance using a configurable AMI, instance type, key pair, count, and user data.
- Two security groups:
  - SSH access on TCP port 22.
  - Web access on TCP ports 80 and 443.
- User data that installs Apache HTTP Server and creates a simple web page.

The default network is used by AWS when no VPC or subnet is explicitly configured.

## Files

| File | Purpose |
| --- | --- |
| `provider.tf` | Terraform and AWS provider requirements and provider configuration |
| `variables.tf` | Input variables and their default values |
| `ec2.tf` | EC2 instance resource |
| `security-group.tf` | SSH and HTTP/HTTPS security groups |
| `.terraform.lock.hcl` | Locked AWS provider version and checksums |

Terraform-generated state and provider cache files are intentionally excluded from Git using the repository root `.gitignore`.

## Prerequisites

- Terraform installed (`>= 1.6.0`)
- AWS CLI installed
- An authenticated AWS CLI profile named `default`
- An existing EC2 key pair named `terraform-key`
- An AMI ID that exists in the selected AWS region

## Terraform Workflow

Run these commands from this directory:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
```

Review the plan carefully. Do not create resources until the plan is understood:

```bash
terraform apply
```

When the exercise is finished, remove the resources to avoid ongoing AWS charges:

```bash
terraform destroy
```

## Useful Variable Overrides

Values can be supplied without changing the Terraform files:

```bash
terraform plan \
  -var='aws_region=eu-central-1' \
  -var='ec2_instance_type=t3.micro' \
  -var='ec2_key_name=terraform-key'
```


## Review Notes Before Apply

1. SSH is currently open to `0.0.0.0/0`. Restrict port 22 to your own public IP or a private administration network.
2. For a VPC instance, prefer `vpc_security_group_ids` with security-group IDs rather than `security_groups` with names.
3. The AMI ID is region-specific and should be verified whenever `aws_region` changes.
4. Consider passing the AWS profile through a variable or environment configuration instead of hard-coding `profile = "default"`.
5. Add outputs such as the instance ID and public IP when those values are needed after deployment.

## Git Commit

The provider lock file should be committed. Terraform state, provider cache, lock metadata, and secret files should remain ignored.

Do not commit files containing AWS credentials, private keys, secrets, `.tfvars` files, Terraform state, plans, or the `.terraform/` directory.
