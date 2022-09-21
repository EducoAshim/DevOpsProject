provider "aws" {
  region = var.aws_region
}

// Create VPC
resource "aws_vpc" "terravpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}


// Create Subnet
resource "aws_subnet" "terra-subnet-public-1" {
  vpc_id                  = aws_vpc.terravpc.id // Referencing the id of the VPC from abouve code block
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" // Makes this a public subnet
  availability_zone       = "us-west-2a"
}

// Create internet Gateway
resource "aws_internet_gateway" "terravpc-igw" {
  vpc_id = aws_vpc.terravpc.id
}

#Create security group 
resource "aws_security_group" "http-ssh-allowed" {
vpc_id = aws_vpc.terravpc.id
name        = var.security_group
description = "security group for Ec2 instance"

egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
   cidr_blocks = ["0.0.0.0/0"] // Ideally best to use your machines' IP. However if it is dynamic you will need to change this in the vpc every so often. 
  }
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create AWS ec2 instance
resource "aws_instance" "TerraEc2" {
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
  security_groups= [var.security_group]
  subnet_id = aws_subnet.terra-subnet-public-1.id
  vpc_security_group_ids = ["${aws_security_group.http-ssh-allowed.id}"]
  tags= {
    Name = var.tag_name
  }
}



# Create Elastic IP address
resource "aws_eip" "TerraEc2ip" {
  vpc      = true
  instance = aws_instance.TerraEc2.id
tags= {
    Name = "terraelastic_ip"
  }
}

