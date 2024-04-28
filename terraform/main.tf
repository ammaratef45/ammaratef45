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

# TODO: variable for vpc id
resource "aws_security_group" "host_sg" {
  vpc_id = "vpc-098d5d6d1fc720f01"
    ingress {
      protocol = "tcp"
      from_port = "22"
      to_port = "22"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
      protocol = "tcp"
      from_port = "80"
      to_port = "80"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
      protocol = "tcp"
      from_port = "443"
      to_port = "443"
      cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 0
      to_port = 0
      protocol = -1
    }
}

resource "aws_security_group" "db_sg" {
  vpc_id = "vpc-098d5d6d1fc720f01"
    ingress {
      protocol = "tcp"
      from_port = "3306"
      to_port = "3306"
      security_groups = [ aws_security_group.host_sg.id ]
    }
    egress {
      cidr_blocks = [ "0.0.0.0/0" ]
      from_port = 0
      to_port = 0
      protocol = -1
    }
}

resource "aws_launch_template" "instance_template" {
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.small"
  vpc_security_group_ids = [aws_security_group.host_sg.id]
  key_name = "wordpressKey"
  user_data = base64encode(data.template_file.user_data.rendered)
  
  iam_instance_profile {
    arn = "arn:aws:iam::835451110523:instance-profile/WordpressBlog-WebServerInstanceProfile-0AkbZpUoOv2z"
  }
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

# TODO: import and manage the role from terraform
# TODO: invoke the lambda weekly
resource "aws_lambda_function" "recycle_lambda" {
  role = "arn:aws:iam::835451110523:role/WordpressBlog-refereshInstancesFunctionServiceRole-1BS5AXEKFTWNX"
  function_name = "WordpressBlog-refereshInstancesFunction5700A864-ThKKJgDXFtOs"
  filename = "${path.module}/refresh/refresh.zip"
  handler = "index.main"
  runtime = "python3.8"
  architectures = [ "x86_64" ]
}
