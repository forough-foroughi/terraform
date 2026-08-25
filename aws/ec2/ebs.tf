resource "aws_ebs_volume" "ec2_ebs" {
  count = var.ec2_instance_count

  availability_zone = aws_instance.ec2-vm[count.index].availability_zone
  size              = var.ec2_ebs_size
  type              = var.ec2_ebs_type
  encrypted         = var.ec2_ebs_encrypted

  tags = {
    Name = "Terraform-EC2-EBS"
  }
  
}