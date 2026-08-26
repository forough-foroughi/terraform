## Terraform AWS EC2 Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-0f417677f9bf398c1" # Amazon Linux AMI ID
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

# key pair name for SSH access
variable "ec2_key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "terraform-key"
}

# user data script for EC2 instance
variable "ec2_user_data" {
  description = "User data script for EC2 instance"
  type        = string
  default     = <<-EOF
                #!/bin/bash
                # Use this for your user data (script from top to bottom)
                # install httpd (Linux 2 version)
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
                EOF
}

# placement group for EC2 instance
variable "placement_group" {
  description = "Placement group name for EC2 instance"
  type        = string
  default     = "placement-group-cluster"

  validation {
    condition     = contains(
      ["placement-group-cluster", "placement-group-spread", "placement-group-partition"],
      var.placement_group
    )
    
    error_message = "Invalid placement group name. Must be one of: placement-group-cluster, placement-group-spread,placement-group-partition."
  } 
}

# EBS volume
variable "ec2_ebs_size" {
  description = "Size of the EBS volume in GB"
  type        = number
  default     = 2
}

variable "ec2_ebs_type" {
  description = "Type of the EBS volume"
  type        = string
  default     = "gp2"
}

variable "ec2_ebs_encrypted" {
  description = "Whether the EBS volume is encrypted"
  type        = bool
  default     = false
}

variable "ec2_ebs_device_name" {
  description = "Device name for the EBS volume attachment"
  type        = string
  default     = "/dev/sdf"
}

# EFS file system
variable "ec2_efs_throughput_mode" {
  description = "Throughput mode for the EFS file system"
  type        = string
  default     = "bursting" # Options: standard, bursting, provisioned
}

variable "ec2_efs_performance_mode" {
  description = "Performance mode for the EFS file system"
  type        = string
  default     = "generalPurpose" # Options: generalPurpose, maxIO
}