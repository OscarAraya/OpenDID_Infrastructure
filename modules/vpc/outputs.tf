output "vpc_id" { value = aws_vpc.main.id }
output "vpc_cidr_block" { value = aws_vpc.main.cidr_block }
output "igw_id" { value = aws_internet_gateway.igw.id }
output "nat_id" { value = aws_nat_gateway.ngw.id }
