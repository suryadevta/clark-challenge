variable "env" {
  default = ""
}

variable "ec2_name" {
  default = "clark"
}

variable "tags" {
  default = {}
}

variable "app_type" {
  default = "private"
}

variable "iam_instance_profile" {
  default = ""
}

variable "ec2_key_name" {
  default = "clark"
}

variable "instance_type" {
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
  default = "10"
}
//variable "asg_tag" {
  //default = {}
//}

variable "vpc_id" {
  default = {}
}

//variable "health_check_path" {
  //default = "/healthz"
//}

//variable "listener_arn" {
  //default = "test"
//}

//variable "host_header" {
  //default = ["example.com"]
//}

variable "enable_ec2_monitoring" {
  default = "true"
}

//variable "enable_autoscaling_metrics" {
  //default = "true"
//}

//variable "sns_topic_arn" {
  //default = {}
//}

variable "code_deploy_role_arn" {
  default = {}
}

variable "deployment_group_name" {
  default = {}
}