provider "aws" {
  region  = var.avail_zone
  version = "4.62.0"
  profile = "tequnity"
}

module "ecr" {
  source   = "./modules/ecr"
  app_name = var.app_name
}

module "network" {
  source            = "./modules/network"
  vpc_cidr_block    = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
  app_name          = var.app_name
  app_port          = var.app_port
  postgres_port     = var.postgres_port
}

module "beanstalk" {
  source          = "./modules/beanstalk"
  env_prefix      = var.env_prefix
  app_name        = var.app_name
  ecr_repo_url    = module.ecr.repository_url
  rds_endpoint    = module.rds.rds_endpoint
  subnet_ids      = [module.network.public_subnet_id]
  security_groups = [module.network.security_group_id]
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
  docker_img_tag  = var.docker_img_tag
  app_port        = var.app_port
  postgres_port   = var.postgres_port
}

module "rds" {
  source                 = "./modules/rds"
  env_prefix             = var.env_prefix
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  subnet_ids             = [module.network.public_subnet_id]
  vpc_security_group_ids = [module.network.security_group_id]
  app_name               = var.app_name
  eb_security_group_id   = module.network.security_group_id
  postgres_port          = var.postgres_port
}
