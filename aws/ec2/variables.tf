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

variable "ec2_key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = "terraform-key"
}

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

variable "placement_group" {
  description = "Placement group name for EC2 instance"
  type        = string
  default     = "placement-group-cluster"

  validation {
    condition     = contains(
      ["placement-group-cluster", "placement-group-spread", "placement-group-partition"],
      var.placement_group
    )
    
    error_message = "Invalid placement group name. Must be one of: placement-group-cluster, placement-group-spread,
                     placement-group-partition."
  } 
}


