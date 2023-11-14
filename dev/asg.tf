resource "aws_launch_template" "tpl" {
  name                   = "LC-${local.env}"
  instance_type          = "t2.micro"
  key_name               = var.key_name
  image_id               = data.aws_ami.base.id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = base64encode(templatefile("${path.module}/efs_mount.sh", {
    efs_mount_point = "/var/www/html"
    file_system_id  = aws_efs_file_system.vol.dns_name
  }))

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 15
    }
  }
}

resource "aws_lb" "lb" {
  name               = "lb-${local.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets = [
    aws_subnet.public-1.id,
    aws_subnet.public-2.id,
    aws_subnet.public-3.id
  ]
}

resource "aws_lb_target_group" "http" {
  name     = "TG--${local.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/status.html"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.com.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_autoscaling_group" "default" {
  name = "ASG-${local.env}"
  availability_zones = [
    aws_subnet.public-1.availability_zone,
    aws_subnet.public-2.availability_zone,
    aws_subnet.public-3.availability_zone
  ]
  desired_capacity = 1
  min_size         = 1
  max_size         = 10

  launch_template {
    id      = aws_launch_template.tpl.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_http" {
  lb_target_group_arn    = aws_lb_target_group.http.arn
  autoscaling_group_name = aws_autoscaling_group.default.name
}
