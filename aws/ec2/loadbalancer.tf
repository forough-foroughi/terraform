# AWS Application Load Balancer (ALB)
resource "aws_lb" "ec2-app-lb" {
  name               = "ec2-app-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"

  security_groups = [aws_security_group.ec2-app-lb.id]
  subnets         = data.aws_subnets.default.ids

  enable_deletion_protection = false

  tags = {
    Name = "Terraform-EC2-LB"
  }

}

resource "aws_lb_target_group" "ec2-app-tg" {
  name             = "ec2-app-tg"
  target_type      = var.ec2_app_lb_type
  port             = 80
  protocol         = "HTTP"
  protocol_version = var.ec2_app_lb_protocol_version
  vpc_id           = data.aws_vpc.default.id

  health_check {
    path     = "/"
    protocol = "HTTP"

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

resource "aws_lb_listener_rule" "ec2-app-listener-rule" {
  listener_arn = aws_lb_listener.ec2-app-listener.arn
  priority     = 5

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not found, custom error!"
      status_code  = "404"
    }
  }

  condition {
    path_pattern {
      values = ["/error"]
    }
  }

}

# AWS Network Load Balancer (NLB)
resource "aws_lb" "ec2-net-lb" {
  name               = "ec2-net-lb"
  internal           = false
  load_balancer_type = "network"
  ip_address_type    = "ipv4"

  security_groups = [aws_security_group.ec2-app-lb.id]
  subnets         = data.aws_subnets.default.ids

  tags = {
    Name = "Terraform-EC2-NLB"
  }

}

resource "aws_lb_target_group" "ec2-net-tg" {
  name     = "ec2-net-tg"
  port     = 80
  protocol = "TCP"

  vpc_id = data.aws_vpc.default.id

  health_check {
    protocol            = "HTTP"
    path                = "/"
    timeout             = 2
    interval            = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "Terraform-EC2-NLB-TG"
  }

}

resource "aws_lb_listener" "ec2-net-listener" {
  load_balancer_arn = aws_lb.ec2-net-lb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2-net-tg.arn
  }

}