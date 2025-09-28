data "aws_availability_zones" "azs" {}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name}-public-subnet" }
}

# Private App Subnet
resource "aws_subnet" "private" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.name}-private-subnet" }
}

# Database Subnet
resource "aws_subnet" "private-data" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_data_subnet_cidr
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.name}-private-data-subnet" }
}

resource "aws_db_subnet_group" "private-data" {
  name        = "${var.name}-private-data-subnet-group"
  subnet_ids  = [var.private_data_subnet_cidr]

  tags        = { Name = "${var.name}-private-data-subnet-group" }
}