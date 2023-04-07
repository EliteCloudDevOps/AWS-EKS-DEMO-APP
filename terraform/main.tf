provider "aws" {
  region  = "us-east-1"
  profile = "testapp"
}  

terraform {
  backend "s3" {
    bucket  = "testapp-tf-bucket"
    key     = "development.tfstate"
    region  = "us-east-1"
    profile = "testapp"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.53.0"
    }
  }  
}

locals {
  common_tags = var.common_tags
  project_name = var.project_name
}

data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:192745211382:secret:development/initial_secrets-p2gYEp"
}
data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}

module "vpc" {
  source              = "./modules/vpc"
  cluster_name        = var.cluster_name
  aws_region          = var.region
  vpc_cidr            = var.vpc_cidr
  region_azs          = var.region_azs
  num_public_subnets  = var.num_public_subnets
  num_private_subnets = var.num_private_subnets
  common_tags         = local.common_tags
  project_name        = local.project_name
}

module "ecr" {
  source = "./modules/ecr"
}

module "s3" {
  source = "./modules/s3"
  objects_expire_days = 60
  project_name  = local.project_name
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  private_subnets = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  eks_api_access  = [module.ec2.vpn_bastion_secgroup]
  common_tags     = local.common_tags
  project_name    = local.project_name  
}

module "ec2" {
  source                = "./modules/ec2"
  bastion_subnet        = module.vpc.public_subnets[0] # us-east-1a
  vpc_id                = module.vpc.vpc_id
  bastion_private_ip    = cidrhost(module.vpc.public_subnets_ranges[0], 10)
  public_key              = var.public_key
  vpn_endpoint          = var.vpn_endpoint
  vpn_route             = var.vpn_route
  bastion_instance_type = var.bastion_instance_type
  common_tags         = local.common_tags
  project_name        = local.project_name  
}

module "kms" {
  source       = "./modules/kms"
  project_name = local.project_name
}

module "secrets" {
  source      = "./modules/secrets"
  kms_key_arn = module.kms.kms_key_arn
  project_name = local.project_name  
}

module "rds" {
  source                       = "./modules/rds"
  project_name                 = local.project_name
  vpc_id                       = module.vpc.vpc_id
  vpc_cidr_block               = module.vpc.vpc_cidr_block
  stateful_private_subnet_a_id = module.vpc.private_subnets[0]
  stateful_private_subnet_b_id = module.vpc.private_subnets[1]
  # kms_key_arn                  = module.kms.kms_key_arn
  postgres_password            = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["postgres_admin_password"]
  depends_on = [
    module.vpc
  ]
}

# module "cloudfront" {
#   source              = "./modules/cloudfront"
#   elb_name            = my_elb
#   domain              = "testapp-web.sysdaemons.com"
#   project_name        = local.project_name
# }