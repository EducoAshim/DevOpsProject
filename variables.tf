variable "aws_region" {
  description = "The AWS region to create resources"
  default     = "us-west-2"
}
variable "PRIVATE_KEY_PATH" {
  default = "aws-key"
}
variable "PUBLIC_KEY_PATH" {
  default = "aws-key.pem"
}

variable "key_name" {
  description = " SSH keys to connect to ec2 instance"
  default     =  "Ec2-jenkins-linux"
}

variable "instance_type" {
  description = "instance type for ec2"
  default     =  "t2.micro"
}

variable "security_group" {
  description = "Name of security group"
  default     = "terraform-security-group"
}

variable "tag_name" {
  description = "Tag Name the resource"
  default     = "Via terraform"
}

variable "ami_id" {
  description = "Amazon Linux-2"
  default     = "ami-0c2ab3b8efb09f272"
}
