## Terraform AWS EC2 Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access (e.g., your IP/32 or VPN CIDR)"
  type        = string
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ec2_instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

# key pair name for SSH access
variable "ec2_key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

# user data script for EC2 instance
variable "ec2_user_data" {
  description = "User data script for EC2 instance"
  type        = string
}

# placement group for EC2 instance
variable "placement_group" {
  description = "Placement group name for EC2 instance"
  type        = string

  validation {
    condition = contains(
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
}

variable "ec2_ebs_type" {
  description = "Type of the EBS volume"
  type        = string
}

variable "ec2_ebs_encrypted" {
  description = "Whether the EBS volume is encrypted"
  type        = bool
}

variable "ec2_ebs_device_name" {
  description = "Device name for the EBS volume attachment"
  type        = string
}

# EFS file system
variable "ec2_efs_throughput_mode" {
  description = "Throughput mode for the EFS file system"
  type        = string
}

variable "ec2_efs_performance_mode" {
  description = "Performance mode for the EFS file system"
  type        = string
}

# Application Load Balancer (ALB)
variable "ec2_app_lb_type" {
  description = "Type of Application Load Balancer"
  type        = string
}

variable "ec2_app_lb_protocol_version" {
  description = "Protocol version for the Application Load Balancer"
  type        = string
}

variable "route53_zone_name" {
  description = "Route 53 zone name"
  type        = string
}

variable "route53_IP_address" {
  description = "Route 53 IP address"
  type        = string
}

variable "weighted_route53_records" {
  description = "Route 53 IP address"
}