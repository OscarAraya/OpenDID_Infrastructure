module "vpc" {
  source            = "../modules/vpc"
  name              = var.name
  # CIDR
  vpc_cidr          = var.vpc_cidr
  # Subnet
  public_subnet_id  = var.public_subnet_cidr
  private_subnet_id = var.private_subnet_cidr
}

module "subnets" {
  source                        = "../modules/subnets"
  name                          = var.name
  # VPC
  vpc_id                        = module.vpc.vpc_id
  public_subnet_cidr            = var.public_subnet_cidr
  private_subnet_cidr           = var.private_subnet_cidr
  private_data_subnet_cidr      = var.private_data_subnet_cidr
}

module "rt" {
  source                  = "../modules/route_table"
  name                    = var.name
  # VPC
  vpc_id                  = module.vpc.vpc_id
  # IGW & NAT
  igw_id                  = module.vpc.igw_id
  nat_id                  = module.vpc.nat_id
  # Subnet
  public_subnet_id        = module.subnets.public_subnet_id
  private_subnet_id       = module.subnets.private_subnet_id
  private_data_subnet_id  = module.subnets.private_data_subnet_id
}

module "sg" {
  source = "../modules/security_groups"
  name   = var.name
  vpc_id = module.vpc.vpc_id
}

module "loadbalancer" {
  source                = "../modules/load_balancers"
  name                  = var.name
  vpc_id                = module.vpc.vpc_id
  # Subnet
  public_subnet_id      = module.subnets.public_subnet_id
  private_subnet_id     = module.subnets.private_subnet_id
  # ALB
  web_alb_sg_id         = module.sg.web_alb_sg_id
  was_alb_sg_id         = module.sg.was_alb_sg_id
  # Instance
  web_ec2_instance_id   = module.ec2.web_ec2_instance_id
  # Variables
  instance_count        = var.instance_count
  was_instance_id       = module.ec2.was_instance_id
}

module "ec2" {
  source            = "../modules/ec2_instances"
  name              = var.name
  # Subnets
  public_subnet_id  = module.subnets.public_subnet_id
  private_subnet_id = module.subnets.private_subnet_id
  # SGs
  bastion_sg_id     = module.sg.bastion_sg_id
  web_alb_sg_id     = module.sg.web_alb_sg_id
  web_ec2_sg_id     = module.sg.web_ec2_sg_id
  was_ec2_sg_id     = module.sg.was_ec2_sg_id
  # Variables
  key_name          = var.key_name
  instance_type     = var.instance_type
  instance_count    = var.instance_count
}

module "cdn" {
  source              = "../modules/cdn"
  name                = var.name
  bucket_name         = var.bucket_name
  aws_lb_web_id       = module.loadbalancer.aws_lb_web_id
  aws_lb_web_name     = module.loadbalancer.aws_lb_web_id
  aws_lb_web_dns_name = module.loadbalancer.aws_lb_web_dns_name
}

module "database" {
  source                    = "../modules/database"
  name                      = var.name
  # Subnets
  private_data_subnet_group_name  = module.subnets.private_data_subnet_group_name
  # SGs
  aurora_sg_id              = module.sg.aurora_sg_id
  # Variables
  instance_class            = var.instance_class
  engine_version            = var.engine_version
  database_name             = var.database_name
  master_username           = var.master_username
  master_password           = var.master_password
  backup_retention_period   = var.backup_retention_period
  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = var.skip_final_snapshot
}