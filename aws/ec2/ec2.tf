# Terraform Configuration for AWS EC2 Instance
data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
  
}

data "aws_vpc" "default" {
  default = true
}

# Create EC2 instance
resource "aws_instance" "ec2-vm" {
    ami           = var.ec2_ami_id
    instance_type = var.ec2_instance_type
    key_name      = var.ec2_key_name
    count         = var.ec2_instance_count
    user_data    = var.ec2_user_data
    # Comment the following line if you want to use ALB with EC2 instance.
    security_groups = [aws_security_group.ec2-ssh.name, aws_security_group.ec2-web.name]
    
    # This line is for using application load balancer with EC2 instance. Uncomment it if you want to use ALB.
    #security_groups = [aws_security_group.ec2-web-lb.name]
    
    #placement_group = aws_placement_group.placement-group-cluster.name
    tags = {
        Name = "Terraform-EC2-Instance"
    }
}

# Create Elastic IP and Associate with EC2 Instance
resource "aws_eip" "ec2-eip" {
    count = var.ec2_instance_count
    domain = "vpc"

    tags = {
        Name = "Terraform-EC2-EIP"
    }
}

resource "aws_eip_association" "ec2-eip-association" {
    count         = var.ec2_instance_count

    instance_id   = aws_instance.ec2-vm[count.index].id
    allocation_id = aws_eip.ec2-eip[count.index].id
}

# Create EC2 Network Interface and Attach to Instance
resource "aws_network_interface" "ec2-eni" {
    count = var.ec2_instance_count

    subnet_id       = data.aws_subnets.default.ids[count.index]
    # private_ips     = ["10.0.0.${count.index + 10}"]
    security_groups = [aws_security_group.ec2-web.id]

    tags = {
        Name = "Terraform-EC2-ENI"
    }
}

resource "aws_network_interface_attachment" "ec2-eni-attachment" {
    count = var.ec2_instance_count

    instance_id          = aws_instance.ec2-vm[count.index].id
    network_interface_id = aws_network_interface.ec2-eni[count.index].id
    device_index        = 1
}

# EBS attachment to EC2 instance
resource "aws_volume_attachment" "ec2-ebs-attachment" {
    count = var.ec2_instance_count
    device_name = var.ec2_ebs_device_name
    volume_id   = aws_ebs_volume.ec2_ebs[count.index].id
    instance_id = aws_instance.ec2-vm[count.index].id

}

# Add EC2 instances to ALB target group
resource "aws_lb_target_group_attachment" "ec2-app-tg-attachment" {
    count = var.ec2_instance_count
    target_group_arn = aws_lb_target_group.ec2-app-tg.arn
    target_id        = aws_instance.ec2-vm[count.index].id
}

# Add EC2 instances to NLB target group
resource "aws_lb_target_group_attachment" "ec2-net-tg-attachment" {
    count = var.ec2_instance_count
    target_group_arn = aws_lb_target_group.ec2-net-tg.arn
    target_id        = aws_instance.ec2-vm[count.index].id
    port             = 80
}