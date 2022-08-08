variable "env" {
    type = string
     default = ""
}

variable "instance_type" {
    type = string
    default = ""
}

variable "availability_zones" {
  type = list(string)
  
}

variable "tags" {
  default = {}
}

variable "instance_ami" {
    type = string
    description = "Server image to use"
    default = ""
}

variable "name" {
  default = ""
}

variable "vpc_id" {
  default = {}
}

variable vpc_cidr_block {
  type = string
  
}
variable "azs" {
  default = ""
}
variable "subnet_id" {
   default = ""
}

variable "description" {
  default = ""
}
variable "ingress_rules" {
  description = "A schema list of ingress rules for the Security Group"
  type        = list(map(string))
  default = []
}
variable "egress_rules" {
  description = "A schema list of egress rules for the Security Group"
  type        = list(map(string))
  default = []
}


variable "ec2_key_name" {
  default = {}
}



variable "security_group" {
  default = {}
}

variable "asg_subnets" {
  default = {}
}

variable "asg_min_size" {
  default = {}
}

variable "asg_desired_size" {
  default = {}
}

variable "asg_max_size" {
  default = {}
}

variable "volume_size" {
  default = {}
}



