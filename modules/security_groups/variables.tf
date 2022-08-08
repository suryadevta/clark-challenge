variable "name" {
  default = ""
  type = string
}
variable "tags" {
  default = {}
}

variable "vpc_id" {
  default = {}
}
variable "description" {
  type = string
  
}
variable "ingress_rules" {
  description = "A schema list of ingress rules for the Security Group"
  //type        = list (map(string))
  default     = [
    {
    description = "description 0",
    from_port = 8500
    to_port=8500
    cidr_blocks = ["0.0.0.0/0"],
    }
  ]
}

variable "egress_rules" {
  description = "A schema list of egress rules for the Security Group"
  //type        = list(map(string))
  default     = [{
      //rule_no    = 100
      //action     = "allow"
    description = "description 1",
    from_port = 0
    to_port =65535
    cidr_blocks = ["0.0.0.0/0"],
    }
  ]  
}
variable "revoke_rules_on_delete" {
  description = "Determines whether to forcibly remove rules when destroying the security group"
  type        = string
  default     = true
}