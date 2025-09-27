output "public_subnet_id"           { value = aws_subnet.public.id }
output "private_subnet_id"          { value = aws_subnet.private.id}
output "aurora_subnet_group_name"   { value = aws_db_subnet_group.aurora.name }