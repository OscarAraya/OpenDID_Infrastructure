# Public Web Application Load Balancer
resource "aws_lb" "web" {
  name               = "${var.name}-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_alb_sg_id]
  subnets            = [var.public_subnet_id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-web-alb"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "web" {
  name     = "${var.name}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Register Web instance with ALB Target Group
resource "aws_lb_target_group_attachment" "web" {
  target_group_arn = aws_lb_target_group.web.arn
  target_id        = var.web_ec2_instance_id
  port             = 80
}

# Private WAS Load Balancer
resource "aws_lb" "was" {
  name               = "was-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.was_alb_sg_id]
  subnets            = [var.private_subnet_id]

  enable_deletion_protection = false

  tags = {
    Name = "was-alb"
  }
}

resource "aws_lb_target_group" "was" {
  name     = "was-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "was" {
  load_balancer_arn = aws_lb.was.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was.arn
  }
}

resource "aws_lb_target_group_attachment" "was" {
  count = var.instance_count

  target_group_arn = aws_lb_target_group.was.arn
  target_id        = var.was_instance_id[count.index]
  port             = 8080
}