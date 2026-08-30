# Create Security Group - SSH Traffic
resource "aws_security_group" "ec2-ssh" {
  name        = "ec2-ssh"
  description = "EC2 SSH"
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }
  egress {
    description = "Allow all IP and Ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group - Web Traffic
resource "aws_security_group" "ec2-web" {
  name        = "ec2-web"
  description = "EC2 Web"

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all IP and Ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group - EFS Traffic
resource "aws_security_group" "ec2-efs" {
  name        = "ec2-efs"
  description = "EC2 EFS"
  egress {
    description = "Allow all IP and Ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Create Security Group - Application Load Balancer Traffic
resource "aws_security_group" "ec2-app-lb" {
  name        = "ec2-app-lb"
  description = "EC2 Application Load Balancer"
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all IP and Ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group - Web Traffic between Load Balancer and EC2 instances
resource "aws_security_group" "ec2-web-lb" {
  name        = "ec2-web-lb"
  description = "EC2 Web Traffic between Load Balancer and EC2 instances"

  # Ingress rules to allow traffic from the Application Load Balancer security group
  ingress {
    description = "Allow Port 80 from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.ec2-app-lb.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

