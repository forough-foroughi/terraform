# Terraform AWS Infrastructure

This repository contains Terraform configurations for managing Amazon Web Services (AWS) infrastructure as code.

## Directory Structure

```
aws/
├── README.md                    # This file
├── ec2/                         # EC2 instance with EBS and EFS
│   ├── provider.tf             # AWS provider configuration
│   ├── variables.tf            # Input variables
│   ├── ec2.tf                  # EC2 instance and networking
│   ├── ebs.tf                  # EBS and EFS storage configuration
│   ├── security-group.tf       # Security groups (SSH, Web, EFS)
│   ├── placement-group.tf      # Placement groups for EC2 clustering
│   ├── outputs.tf              # Output values (IPs, IDs, etc.)
│   ├── .terraform.lock.hcl     # Provider version lock file
│   └── README.md               # EC2 module documentation
```

---

## Modules Overview

### EC2 Module

Complete EC2 infrastructure with storage and networking:

#### Resources Created
- **EC2 Instance**: Configurable instance type with user data
- **Storage**:
  - EBS Volume: Additional block storage with encryption option
  - EFS File System: Shared file system across instances with automated backups
- **Networking**:
  - Elastic IP: Static public IP address
  - ENI: Elastic Network Interfaces for multi-homing
  - Default VPC and subnets
- **Security Groups**:
  - SSH (Port 22) - restricted by default to 0.0.0.0/0, change to your IP
  - HTTP/HTTPS (Ports 80, 443)
  - EFS NFS (Port 2049)
- **Placement Groups**: Optional cluster, spread, or partition strategies

#### Key Features
- ✅ Multi-instance support via `count`
- ✅ Automatic EFS mount targets in all AZs
- ✅ User data for application bootstrap
- ✅ Comprehensive outputs for easy resource discovery
- ✅ Backup policies for EFS
- ✅ Network redundancy and failover support

---

## Prerequisites

### System Requirements
- **Terraform**: `>= 1.6.0`
- **AWS CLI**: Latest version
- **Authentication**: AWS credentials configured (AWS CLI profile or environment variables)

### AWS Prerequisites
- **EC2 Key Pair**: Must exist in the target region
  ```bash
  aws ec2 describe-key-pairs --region eu-central-1
  ```
- **AMI ID**: Valid Amazon Linux 2 or similar in target region
  ```bash
  # Find latest Amazon Linux 2 AMI
  aws ec2 describe-images \
    --owners amazon \
    --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
    --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
    --region eu-central-1
  ```

### Verification
```bash
# Check Terraform version
terraform version

# Verify AWS credentials
aws sts get-caller-identity

# Check key pair exists
aws ec2 describe-key-pairs --region eu-central-1 --query 'KeyPairs[*].KeyName'
```

---

## Quick Start

### 1. Initialize Terraform
```bash
cd aws/ec2
terraform init
```

### 2. Review Configuration
```bash
terraform fmt              # Format code
terraform validate         # Check syntax
terraform plan             # Preview changes
```

### 3. Deploy Infrastructure
```bash
# Standard deployment
terraform apply

# Auto-approve (use carefully!)
terraform apply -auto-approve
```

### 4. Retrieve Outputs
```bash
# Show all outputs
terraform output

# Get specific values
terraform output instance_public_ips
terraform output efs_dns_name
terraform output ssh_connection_command
```

### 5. Connect to Instance
```bash
# SSH into instance (replace with actual IP)
ssh -i /path/to/terraform-key.pem ec2-user@<PUBLIC_IP>

# Or use the connection command from outputs
eval "$(terraform output -raw ssh_connection_command[0])"
```

### 6. Clean Up
```bash
terraform destroy
# Or with auto-approve
terraform destroy -auto-approve
```

---

## Configuration & Customization

### Override Default Variables

#### Command Line
```bash
terraform plan -var='aws_region=us-east-1' \
               -var='ec2_instance_type=t3.small' \
               -var='ec2_instance_count=2'
```

#### Environment Variables
```bash
export TF_VAR_aws_region='us-west-2'
export TF_VAR_ec2_instance_type='t3.medium'
export TF_VAR_allowed_ssh_cidr='203.0.113.0/24'  # Your IP
```

#### Terraform Variables File
```bash
# Create terraform.tfvars
cat > terraform.tfvars <<EOF
aws_region           = "us-east-1"
ec2_instance_type    = "t3.small"
ec2_instance_count   = 2
ec2_ebs_size         = 10
allowed_ssh_cidr     = "YOUR_IP/32"
EOF

terraform plan
```

### Key Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `aws_region` | AWS region | `eu-central-1` | `us-east-1` |
| `ec2_instance_type` | Instance type | `t3.micro` | `t3.small`, `m5.large` |
| `ec2_instance_count` | Number of instances | `1` | `2`, `3` |
| `ec2_ami_id` | Amazon Machine Image ID | `ami-0f417...` | Region-specific |
| `ec2_key_name` | EC2 Key Pair name | `terraform-key` | Your key name |
| `ec2_ebs_size` | EBS volume size (GB) | `2` | `10`, `100` |
| `allowed_ssh_cidr` | SSH source CIDR | `0.0.0.0/0` | `YOUR_IP/32` |
| `ec2_efs_throughput_mode` | EFS throughput | `bursting` | `provisioned`, `elastic` |

---

## Security Considerations

### ⚠️ Critical Security Issues

1. **SSH Access**: Default allows `0.0.0.0/0`
   - **Fix**: Set `allowed_ssh_cidr` to your IP or VPN CIDR:
   ```bash
   terraform plan -var='allowed_ssh_cidr=203.0.113.45/32'
   ```

2. **Hard-coded Profile**: AWS CLI profile is hard-coded as `default`
   - **Fix**: Use environment variables or IAM role:
   ```bash
   export AWS_PROFILE=my-profile
   # or use IAM role on EC2
   ```

3. **Credentials in State**: Terraform state contains sensitive data
   - **Solution**: Use `terraform.lock.hcl` for locking, store state in S3 with encryption
   - **Action**: Never commit state files to Git

### Best Practices

- ✅ Restrict SSH CIDR before applying
- ✅ Use IAM roles for EC2 instead of embedding credentials
- ✅ Enable EBS encryption in production
- ✅ Implement VPC security group chaining
- ✅ Use NACLs (Network ACLs) for subnet-level control
- ✅ Monitor EC2 with CloudWatch
- ✅ Regularly rotate SSH keys
- ✅ Use VPN or bastion hosts for production access

---

## Cost Optimization

### Estimate Costs
```bash
terraform plan -json | terraform cost-estimation
```

### Money-Saving Tips
- **Instance Type**: `t3.micro` is free-tier eligible
- **EBS**: Use `gp3` instead of `gp2` for better price/performance
- **EFS**: Consider `One Zone` storage class if redundancy not needed
- **Scheduling**: Stop instances during off-hours:
  ```bash
  aws ec2 stop-instances --instance-ids i-1234567890abcdef0
  aws ec2 start-instances --instance-ids i-1234567890abcdef0
  ```

### Cost Breakdown (Hourly, eu-central-1)
- t3.micro: ~$0.01/hour
- EBS (gp2, 2GB): ~$0.0002/hour
- EFS: ~$0.30/GB-month + $0.02/GB provisioned
- Elastic IP: $0.005/hour (if not attached)

---

## Troubleshooting

### Common Issues

#### 1. "Error: creating EC2 Instance: operation error EC2: RunInstances, ... InvalidParameterCombination: Cluster placement groups are not supported"
- **Cause**: Cluster placement group incompatible with t3.micro
- **Fix**: Remove placement group or use larger instance type (c5.large, m5.large)

#### 2. "Error: Subnet validation failed"
- **Cause**: AZ-specific subnet doesn't exist
- **Fix**: Check available subnets:
  ```bash
  aws ec2 describe-subnets --filters "Name=default-for-az,Values=true"
  ```

#### 3. "Error: No provider configured" or "Error initializing providers"
- **Cause**: `terraform init` not run
- **Fix**: Run `terraform init` first

#### 4. SSH Connection Timeout
- **Cause**: Security group doesn't allow port 22 from your IP
- **Fix**: Update security group inbound rules:
  ```bash
  terraform apply -var='allowed_ssh_cidr=YOUR_IP/32'
  ```

#### 5. "The key pair name does not exist"
- **Cause**: EC2 key pair not created in region
- **Fix**: Create key pair or verify region:
  ```bash
  aws ec2 create-key-pair --key-name terraform-key --region eu-central-1
  ```

---

## Outputs

The EC2 module generates useful outputs:

```bash
terraform output instance_ids              # EC2 instance IDs
terraform output instance_public_ips       # Elastic IP addresses
terraform output efs_dns_name              # EFS mount point
terraform output ssh_connection_command    # Ready-to-use SSH command
terraform output security_group_ids        # Security group IDs
```

---

## Working with State

### Local State (Development Only)
```bash
# State is stored in terraform.tfstate
# Review current state
terraform state list
terraform state show aws_instance.ec2-vm
```

## Git & Version Control

### Files to Commit
- ✅ `*.tf` (Terraform configuration)
- ✅ `.terraform.lock.hcl` (Provider versions)
- ✅ `*.tfvars.example` (Variable templates, no secrets)
- ✅ `README.md` and documentation

### Files to IGNORE (in .gitignore)
- ❌ `terraform.tfstate*` (Contains sensitive data)
- ❌ `.terraform/` (Provider cache)
- ❌ `*.tfvars` (Contains secrets)
- ❌ `*.pem`, `*.key` (Private keys)
- ❌ `crash.log`
- ❌ `.DS_Store`, `.env`


## Advanced Topics

### Scaling to Multiple Instances
```bash
terraform apply -var='ec2_instance_count=3'
# This creates 3 instances, 3 EBS volumes, and 3 Elastic IPs
```

### Using Placement Groups
```bash
# For compute-optimized clustering:
terraform apply -var='ec2_instance_type=c5.large' \
                -var='placement_group=placement-group-cluster'
```

### Provisioning with User Data
Modify `ec2_user_data` in `variables.tf` for custom bootstrap scripts:
```bash
terraform apply -var='ec2_user_data=@custom-script.sh'
```

### Monitoring & Logging
```bash
# Watch EC2 logs
tail -f terraform.tfstate | jq '.resources[] | select(.type=="aws_instance")'

# CloudWatch logs
aws logs tail /aws/ec2/terraform-ec2-instance --follow
```

---

## Support & Documentation

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [AWS EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [Terraform Best Practices](https://www.terraform.io/cloud-docs/guides/recommended-practices)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)


