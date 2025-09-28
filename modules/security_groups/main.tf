# Public Security Groups - WEB ALB
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
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

  tags = {
    Name = "${var.name}-bastion-sg"
  }
}

resource "aws_security_group" "web_alb" {
  name        = "web-alb-sg"
  description = "Security group for web application load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

# Security Group for Web EC2 instances
resource "aws_security_group" "web_ec2" {
  name        = "web-ec2-sg"
  description = "Security group for web EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb.id]
  }

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
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

# Private Security Groups - WAS ALB
resource "aws_security_group" "was_alb" {
  name        = "was-alb-sg"
  description = "Security group for WAS application load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from Web ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.web_ec2.id]
  }

  ingress {
    description     = "HTTPS from Web ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "was-alb-sg"
  }
}

resource "aws_security_group" "was_ec2" {
  name        = "was-ec2-sg"
  description = "Security group for WAS EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from WAS ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.was_alb.id]
  }

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "was-ec2-sg"
  }
}

# Web EC2 SG to allow outbound to WAS ALB
resource "aws_security_group_rule" "web_to_was" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.was_alb.id
  security_group_id        = aws_security_group.web_ec2.id
}

# Database
resource "aws_security_group" "aurora" {
  name        = "${var.name}-aurora-sg"
  description = "Security group for Aurora PostgreSQL"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from WAS instances"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.was_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-aurora-sg"
  }
}

## CDN
# Security Group Rule to Allow CloudFront to Access ALB
resource "aws_security_group_rule" "cloudfront_to_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.web_alb.id
  
  # Allow CloudFront IP ranges (recommended for better security)
  cidr_blocks       = data.aws_ip_ranges.cloudfront.cidr_blocks
  
  description       = "Allow traffic from CloudFront to ALB"
}

# Security Group Rule - Only allow CloudFront via HTTPS
# resource "aws_security_group_rule" "cloudfront_https_to_alb" {
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   security_group_id = aws_security_group.web_alb.id
#   cidr_blocks       = data.aws_ip_ranges.cloudfront.cidr_blocks
#   description       = "Allow HTTPS from CloudFront to ALB"
# }
