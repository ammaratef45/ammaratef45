terraform {
  cloud {
    organization = "ammaratef45"
    workspaces {
      name = "ammaratef45"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
 
provider "aws" {
 region = "us-east-1"
}

resource "aws_launch_template" "instance_template" {
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.small"
}

resource "aws_autoscaling_group" "instances" {
  min_size = 1
  max_size = 2
  launch_template {
    id = aws_launch_template.instance_template.id
    version = "$Latest"
  }
  force_delete = false
  force_delete_warm_pool = false
  health_check_grace_period = 300
  termination_policies = [ "OldestInstance" ]
}