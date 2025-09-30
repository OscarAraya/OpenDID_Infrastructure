# 1. Bastion Host Instance
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0] # Se utiliza la primer referencia
  vpc_security_group_ids = [var.bastion_sg_id]
  key_name               = var.key_name

  tags = { Name = "${var.name}-bastion-host" }
}

# # Web EC2 Instance
# resource "aws_instance" "web" {
#   ami                    = data.aws_ami.amazon_linux.id
#   instance_type          = var.instance_type
#   subnet_id              = var.public_subnet_ids[0]
#   vpc_security_group_ids = [var.web_ec2_sg_id]
#   key_name               = var.key_name

#   tags = {
#     Name = "${var.name}-ec2-web"
#   }
# }

# # WAS EC2 Instances
# resource "aws_instance" "was" {
#   count                  = var.instance_count

#   ami                    = data.aws_ami.amazon_linux.id
#   instance_type          = var.instance_type
#   subnet_id              = var.private_subnet_ids[0]
#   vpc_security_group_ids = [var.was_ec2_sg_id]
#   key_name               = var.key_name

#   tags = {
#     Name = "${var.name}-was-ec2-${count.index + 1}"
#   }
# }