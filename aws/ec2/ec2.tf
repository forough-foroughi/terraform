# Create EC2 instance
resource "aws_instance" "ec2-vm" {
    ami           = var.ec2_ami_id
    instance_type = var.ec2_instance_type
    key_name      = var.ec2_key_name
    count         = var.ec2_instance_count
    user_data    = var.ec2_user_data
    security_groups = [aws_security_group.ec2-ssh.name, aws_security_group.ec2-web.name]
    placement_group = aws_placement_group.placement-group-cluster.name
    tags = {
        Name = "Terraform-EC2-Instance"
    }
}

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

