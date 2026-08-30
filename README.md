This repo is my experience in terraform



## Useful Commands Reference

```bash
# Planning & Validation
terraform fmt                 # Format code
terraform validate            # Check syntax
terraform plan               # Show changes
terraform plan -out=tfplan   # Save plan to file
terraform show tfplan        # Show saved plan

# Apply & Destroy
terraform apply              # Apply with confirmation
terraform apply tfplan       # Apply saved plan
terraform destroy            # Destroy with confirmation

# Inspection
terraform output             # Show all outputs
terraform state list         # List resources
terraform state show <addr>  # Show resource details
terraform console            # Interactive console

# Refactoring
terraform state mv <old> <new>   # Move resource in state
terraform state rm <addr>        # Remove from state
terraform import <addr> <id>     # Import existing resource
```

---
### Remote State (Recommended for Production)
```hcl
# Add to provider.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "aws/ec2/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

---

### Example Commit Workflow
```bash
# Check what will be committed
git status

# Add Terraform files
git add *.tf .terraform.lock.hcl README.md

# Verify nothing sensitive is added
git diff --staged

# Commit
git commit -m "Add EC2 Terraform configuration with EBS and EFS"
git push origin main
```

---

## License

This Terraform configuration is provided as-is for educational and infrastructure management purposes.

**Last Updated**: 2026-08-30