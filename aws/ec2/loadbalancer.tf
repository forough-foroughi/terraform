# AWS Application Load Balancer (ALB)
resource "aws_lb" "ec2-app-lb" {
    name               = "ec2-app-lb"
    internal           = false
    load_balancer_type = "application"
    ip_address_type   = "ipv4"

    security_groups    = [aws_security_group.ec2-app-lb.id]
    subnets            = data.aws_subnets.default.ids
    
    enable_deletion_protection = false
    
    tags = {
        Name = "Terraform-EC2-LB"
    }
  
}

resource "aws_lb_target_group" "ec2-app-tg" {
    name     = "ec2-app-tg"
    target_type = var.ec2_app_lb_type
    port     = 80
    protocol = "HTTP"
    protocol_version = var.ec2_app_lb_protocol_version
    vpc_id   = data.aws_vpc.default.id

    health_check {
        path                = "/"
        protocol            = "HTTP"

    }

    tags = {
        Name = "Terraform-EC2-TG"
    }
  
}

resource "aws_lb_listener" "ec2-app-listener" {
    load_balancer_arn = aws_lb.ec2-app-lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.ec2-app-tg.arn
    }
  
}

# scheme = "internet-facing", "internal"
