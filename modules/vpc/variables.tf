variable "name"                     { type = string }
variable "vpc_cidr"                 { type = string }
variable "public_subnet_ids"        { type = list(string) }
variable "private_subnet_ids"       { type = list(string) }
variable "vpc_availability_zones"   { type = list(string) }