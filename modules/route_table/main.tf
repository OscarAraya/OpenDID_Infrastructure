resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  count  = length(var.public_subnet_ids)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags   = { Name = "${var.name}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  route_table_id = aws_route_table.public[count.index].id
  subnet_id      = var.public_subnet_ids[count.index]
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  count  = length(var.public_subnet_ids)
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }

  tags   = { Name = "${var.name}-private-rt" }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = var.private_subnet_ids[count.index]
}