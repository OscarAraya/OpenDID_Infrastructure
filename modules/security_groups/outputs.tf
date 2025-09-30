output "web_alb_sg_id" { value = aws_security_group.web_alb_sg.id }
output "web_ec2_sg_id" { value = aws_security_group.web_ec2_sg.id }
output "was_alb_sg_id" { value = aws_security_group.was_alb_sg.id }
output "was_ec2_sg_id" { value = aws_security_group.was_ec2_sg.id }
output "bastion_sg_id" { value = aws_security_group.bastion_sg.id }