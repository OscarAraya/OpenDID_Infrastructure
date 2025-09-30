variable "name"                 { type = string }
variable "vpc_id"               { type = string }
variable "igw_id"               { type = string }
# Subnet
variable "public_subnet_ids"    { type = list(string) }
variable "private_subnet_ids"   { type = list(string) }
# Security Groups
variable "web_alb_sg_id"        { type = string }
variable "was_alb_sg_id"        { type = string }