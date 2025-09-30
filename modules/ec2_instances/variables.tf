variable "name"                 { type = string }
#Subnets
variable "public_subnet_ids"    { type = list(string) }
variable "private_subnet_ids"   { type = list(string) }
# Security Groups
variable "bastion_sg_id"        { type = string }
variable "web_ec2_sg_id"        { type = string }
variable "was_ec2_sg_id"        { type = string }
# Variables
variable "key_name"             { type = string }
variable "instance_type"        { type = string }
variable "instance_count"       { type = string }