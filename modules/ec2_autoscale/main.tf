data "aws_ami" "ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["consul-amazon-linux-2-2022-08-06T09-29-43Z-62ee3487-0419-b86f-fbc3-1af2cf13bae7"]
  }
  owners = ["self","amazon"]
}


resource "aws_launch_template" "launch_template" {
  name                   = "clark-${var.env}-lt-ec2-${var.ec2_name}"
  description            = "Launch Template for ${var.ec2_name}"
  update_default_version = "true"
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = var.volume_size
    }
  }
  iam_instance_profile {
    name = "clark-${var.env}-lt-ec2-${var.ec2_name}"
  }
  
  monitoring {
    enabled = var.enable_ec2_monitoring
  }
  lifecycle {
    create_before_destroy = true
  }
  key_name               = var.ec2_key_name
  instance_type          = var.instance_type
  image_id               = data.aws_ami.ami.id
  vpc_security_group_ids = var.security_group
  tags                   = merge({ Name = "clark-${var.env}-lt-ec2-${var.ec2_name}"})
  user_data = filebase64("${path.module}/user-data/user-data.sh")
              
              //<<-EOF
              #!/bin/bash
              ///opt/consul/bin/run-consul --server --cluster-tag-key consul-cluster --cluster-tag-value consul-cluster-example
              //EOF
              //filebase64("${path.module}/example.sh")
}

resource "aws_iam_instance_profile" "instance_profile" {
    name = "clark-${var.env}-lt-ec2-${var.ec2_name}"
    role = aws_iam_role.role.name 
  }

  resource "aws_iam_role" "role" {
  name = "test_role"
  path = "/"
  managed_policy_arns = [aws_iam_policy.policy_new.arn]
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
resource "aws_iam_policy" "policy_new" {
  name = "clark-${var.env}-lt-ec2-${var.ec2_name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement= [{
    Effect = "Allow"

    Action = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "autoscaling:DescribeAutoScalingGroups"
    ]

    Resource = "*"
  }
    ]
})
}

###############################
# Creating Autoscaling group
###############################
resource "aws_autoscaling_group" "autoscaling_group" {
  name                  = "clark-${var.env}-asg-ec2-${var.ec2_name}"
  protect_from_scale_in = "false"
  vpc_zone_identifier   = var.asg_subnets
  min_size              = var.asg_min_size
  max_size                  = var.asg_max_size
  health_check_grace_period = "300"
  health_check_type         = "EC2"
  termination_policies      = ["NewestInstance"]
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "clark-${var.env}-asg-ec2-${var.ec2_name}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Autoscaling"
    value               = "Yes"
    propagate_at_launch = true
  }
  tag {
    key                 = "Creation"
    value               = "Terraform"
    propagate_at_launch = false
  }
  tag{
    key     = "consul-cluster"
    value   = "consul-cluster-example"
    propagate_at_launch = true

  }
}
###############################
#scaling policy for CPU
###############################
resource "aws_autoscaling_policy" "cpu_high" {
  name                      = "clark-${var.env}-autoscale-ec2-${var.ec2_name}-cpu"
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 120
  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}