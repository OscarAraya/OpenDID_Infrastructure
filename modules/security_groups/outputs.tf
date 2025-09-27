output "bastion_sg_id" { value = aws_security_group.bastion.id }
output "web_alb_sg_id" { value = aws_security_group.web_alb.id }
output "was_alb_sg_id" { value = aws_security_group.was_alb.id }
output "web_ec2_sg_id" { value = aws_security_group.web_ec2.id }
output "was_ec2_sg_id" { value = aws_security_group.was_ec2.id }
output "aurora_sg_id"  { value = aws_security_group.aurora.id }