# 1. WEB Application Load Balancer
resource "aws_lb" "web_lb" {
    name = "${var.name}-web-lb"
    load_balancer_type = "application"
    internal = false

    security_groups = [var.web_alb_sg_id]

    subnets = var.public_subnet_ids

    depends_on = [ var.igw_id ]

    tags = { Name = "${var.name}-web-lb" }
}

# 2. WEB ALB Target Group
resource "aws_lb_target_group" "web_alb_ec2_tg" {
  name = "${var.name}-web-lb-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = { Name = "${var.name}-web-lb-tg" }
}

# 3. WEB ALB Listener
resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_alb_ec2_tg.arn
  }
  tags = { Name = "${var.name}-web_alb_listener" }
}

#--------------------------------------------------
# 1. WAS Application Load Balancer
resource "aws_lb" "was_lb" {
    name = "${var.name}-was-lb"
    load_balancer_type = "application"
    internal = false

    security_groups = [var.was_alb_sg_id]

    subnets = var.private_subnet_ids

    depends_on = [ var.igw_id ]

    tags = { Name = "${var.name}-was-lb" }
}

# 2. WAS ALB Target Group
resource "aws_lb_target_group" "was_alb_web_tg" {
  name = "${var.name}-was-lb-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id = var.vpc_id
  tags = { Name = "${var.name}-was-lb-tg" }
}

# 3. WAS ALB Listener
resource "aws_lb_listener" "was_alb_listener" {
  load_balancer_arn = aws_lb.was_lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.was_alb_web_tg.arn
  }
  tags = { Name = "${var.name}-was-alb-listener" }
}