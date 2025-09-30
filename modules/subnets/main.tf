resource "aws_subnet" "public" {
  vpc_id            = var.vpc_id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index+1)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags              = { Name = "${var.name}-subnet-public-${count.index+1}" }
}

resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  count             = length(var.vpc_availability_zones)
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index+3)
  availability_zone = element(var.vpc_availability_zones, count.index)
  tags              = { Name = "${var.name}-subnet-private-${count.index+1}" }
}

resource "aws_db_subnet_group" "private_data" {
  name        = "${var.name}-private-data-subnet-group"
  subnet_ids  = aws_subnet.private[*].id

  tags        = { Name = "${var.name}-private-data-subnet-group" }
}