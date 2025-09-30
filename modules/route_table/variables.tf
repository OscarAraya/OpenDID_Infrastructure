variable "name"                     { type = string }
variable "vpc_id"                   { type = string }
variable "vpc_availability_zones"   { type = list(string) }
variable "igw_id"                   { type = string }
variable "nat_id"                   { type = string }
variable "public_subnet_ids"        { type = list(string) }
variable "private_subnet_ids"       { type = list(string) }