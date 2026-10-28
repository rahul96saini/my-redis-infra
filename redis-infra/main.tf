terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. VPC & IGW Module
module "vpc" {
  source = "./vpc"
}

# 2. Subnet Module (1 Public + 3 Private Subnets)
module "subnet" {
  source = "./subnet"
  vpc_id = module.vpc.vpc_id
}

# 3. Route Table Module
module "route_table" {
  source             = "./route_table"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.vpc.igw_id
  public_subnet_id   = module.subnet.public_subnet_id
  private_subnet_ids = [
    module.subnet.private_subnet_1_id,
    module.subnet.private_subnet_2_id,
    module.subnet.private_subnet_3_id
  ]
}

# 4. Security Group Module
module "security_group" {
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
}

# 5. Compute Module (1 Bastion + 3 Redis Nodes)
module "compute" {
  source             = "./compute"
  public_subnet_id   = module.subnet.public_subnet_id
  private_subnet_ids = [
    module.subnet.private_subnet_1_id,
    module.subnet.private_subnet_2_id,
    module.subnet.private_subnet_3_id
  ]
  security_group_ids = [module.security_group.sg_id]
  key_name           = var.key_name
}