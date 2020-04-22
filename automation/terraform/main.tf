provider "aws" {
  version    = "~> 2.0"
  profile    = "default"
  region     = "eu-west-3"
}

resource "aws_key_pair" "app-key" {
  key_name   = "app"
  public_key = file(var.ssh_public_key_file)
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name  = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_default_security_group" "default" {
  #vpc_id      = "${aws_default_vpc.default.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

module "staging" {
  source            = "./application"
  instance_type     = var.staging_instance_type
  instance_ami      = data.aws_ami.ubuntu.id
  instance_count    = 1
  instance_key_name = aws_key_pair.app-key.key_name
  stage             = "staging"
}

module "production" {
  source            = "./application"
  instance_type     = var.staging_instance_type
  instance_ami      = data.aws_ami.ubuntu.id
  instance_count    = 2
  instance_key_name = aws_key_pair.app-key.key_name
  stage             = "production"
}