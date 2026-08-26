# EBS Volume Configuration
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


# EFS File System Configuration
resource "aws_efs_file_system" "ec2_efs" {
    lifecycle_policy {
        transition_to_ia = "AFTER_30_DAYS"
    }
    throughput_mode = var.ec2_efs_throughput_mode
    performance_mode = var.ec2_efs_performance_mode
    encrypted = true
    tags = {
        Name = "Terraform-EC2-EFS"
    }
  
}

resource "aws_efs_backup_policy" "ec2_efs_backup" {
  file_system_id = aws_efs_file_system.ec2_efs.id
  backup_policy {
    status = "ENABLED"
  }
}

resource "aws_efs_mount_target" "ec2_efs" {
    file_system_id  = aws_efs_file_system.ec2_efs.id
    subnet_id       = data.aws_subnets.default.ids[0]
    security_groups = [aws_security_group.ec2-efs.id]  
}