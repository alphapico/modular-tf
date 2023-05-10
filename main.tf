terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "tequnity"
}

module "ecr" {
  source   = "./modules/ecr"
  app_name = var.app_name
}

module "network" {
  source              = "./modules/network"
  vpc_cidr_block      = var.vpc_cidr_block
  subnet_cidr_block_1 = var.subnet_cidr_block_1
  avail_zone_1        = var.avail_zone_1
  subnet_cidr_block_2 = var.subnet_cidr_block_2
  avail_zone_2        = var.avail_zone_2
  env_prefix          = var.env_prefix
  app_name            = var.app_name
  app_port            = var.app_port
  postgres_port       = var.postgres_port
}

module "beanstalk" {
  source          = "./modules/beanstalk"
  env_prefix      = var.env_prefix
  app_name        = var.app_name
  ecr_repo_url    = module.ecr.ecr_repository_url
  rds_endpoint    = module.rds.rds_endpoint
  vpc_id          = module.network.vpc_id
  subnet_ids      = [module.network.public_subnet_id_1]
  security_groups = [module.network.security_group_id]
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
  docker_img_tag  = var.docker_img_tag
  app_port        = var.app_port
  postgres_port   = var.postgres_port
  region          = var.region
  jwt_secret      = var.jwt_secret
  frontend_domain = var.frontend_domain
  email_name      = var.email_name
  email_from      = var.email_from
}

module "rds" {
  source                 = "./modules/rds"
  env_prefix             = var.env_prefix
  db_name                = var.db_name
  db_username            = var.db_username
  db_password            = var.db_password
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  subnet_ids             = [module.network.public_subnet_id_1, module.network.public_subnet_id_2]
  vpc_security_group_ids = [module.network.security_group_id]
  app_name               = var.app_name
  postgres_port          = var.postgres_port
}
