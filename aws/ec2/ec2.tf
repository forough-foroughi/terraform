# Create EC2 instance
resource "aws_instance" "ec2-vm" {
    ami           = var.ec2_ami_id
    instance_type = var.ec2_instance_type
    key_name      = var.ec2_key_name
    count         = var.ec2_instance_count
    user_data    = var.ec2_user_data
    security_groups = [aws_security_group.ec2-ssh.name, aws_security_group.ec2-web.name]
    tags = {
        Name = "Terraform-EC2-Instance"
    }
    }