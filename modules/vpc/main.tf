# VPC
resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags                  = { Name = "${var.name}-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name}-igw" }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain  = "vpc"

  depends_on    = [aws_internet_gateway.igw]
  tags    = { Name = "${var.name}-nat-eip" }
}

# NAT Gateway
resource "aws_nat_gateway" "ngw" {
  subnet_id = var.private_subnet_ids[0] # Se utiliza primer referencia
  allocation_id = aws_eip.nat.id

  depends_on    = [aws_internet_gateway.igw]
  tags          = { Name = "${var.name}-ngw" }
}