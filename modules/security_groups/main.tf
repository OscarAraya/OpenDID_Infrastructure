# 1. Security Group for WEB ALB (Internet -> WEB ALB)
resource "aws_security_group" "web_alb_sg" {
  name        = "${var.name}-web-alb-sg"
  description = "Security group for WEB ALB"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-web-alb-sg"
  }
}

# 2. Security Group for EC2 (WEB ALB -> WEB EC2)
resource "aws_security_group" "web_ec2_sg" {
  name        = "${var.name}-web-ec2-sg"
  description = "Security group for WEB EC2"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = [aws_security_group.web_alb_sg.id]
    security_groups = [aws_security_group.web_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-web-ec2-sg"
  }
}

# 3. Security Group for WAS ALB (WEB EC2 -> WEB ALB)
resource "aws_security_group" "was_alb_sg" {
  name        = "${var.name}-was-alb-sg"
  description = "Security group for WAS ALB"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = [aws_security_group.web_ec2_sg.id]
    security_groups = [aws_security_group.web_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-was-alb-sg" }
}

# 4. Security Group for WAS EC2 (WAS ALB -> WAS EC2)
resource "aws_security_group" "was_ec2_sg" {
  name        = "${var.name}-was-ec2-sg"
  description = "Security group for WAS EC2"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    #cidr_blocks = [aws_security_group.was_alb_sg.id]
    security_groups = [aws_security_group.was_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-was-ec2-sg" }
}

# 5. Security Group for Bastion Host
resource "aws_security_group" "bastion_sg" {
  name        = "${var.name}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-bastion-sg" }
}