provider "aws" {
  region     = "us-east-1"
  version    = ">= 3.63.0"
  access_key = "AKIAREH3QZRNKBBK5FWA"
  secret_key = "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"
}


terraform {
  backend "s3"{
      bucket = "clark-statefiles"
      key = "terraform.tfstate"
      region = "us-east-1"
      
      
      
  }
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr_block= var.vpc_cidr_block
  env= var.env
  availability_zones=var.availability_zones
  
}
module "security_group"{
  source ="./modules/security_groups"
  name=var.name
  vpc_id = "${module.vpc.vpc_id}"
  description = var.description

} 


module "ec2_autoscale"{
  source ="./modules/ec2_autoscale"
  vpc_id = "${module.vpc.vpc_id}"
  env =var.env
  security_group= ["${module.security_group.id}"]
  asg_max_size=var.asg_max_size 
  asg_min_size=var.asg_min_size
  asg_subnets= module.vpc.subnet_public
  instance_type= var.instance_type
  asg_desired_size=var.asg_desired_size
  
}

