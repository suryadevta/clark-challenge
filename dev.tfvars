availability_zones= ["us-east-1a","us-east-1b","us-east-1c"]

vpc_cidr_block = "10.0.0.0/16"
  
env= "dev"

tags = {
    "env"       = "dev"
    "createdBy" = "Robinder"
  }

instance_type  = "t3.micro"  

instance_ami = "ami-090fa75af13c156b4"

name ="dev_sec_group"

description = "new_secgroup"

asg_max_size=5

asg_min_size=3

asg_desired_size=3


