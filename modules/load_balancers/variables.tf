variable "name"                 { type = string }
variable "vpc_id"               { type = string }
# Instance
variable "web_ec2_instance_id"  { type = string }
variable "was_instance_id"      { type = list(string) }
# Subnet
variable "public_subnet_id"     { type = string }
variable "private_subnet_id"    { type = string }
# Security Groups
variable "web_alb_sg_id"        { type = string }
variable "was_alb_sg_id"        { type = string }
# Variables
variable "instance_count"       { type = string }