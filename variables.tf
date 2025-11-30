variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "env" {
  type        = string
  description = "Environment name"
  validation {
    condition     = contains(["dev", "prod"], var.env)
    error_message = "Environment must be dev or prod."
  }
}

variable "aws_region" {
  type = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "subnet_numbers" {
  type        = list(number)
  description = "List of subnet numbers"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2"
}

variable "create_ec2" {
  type        = bool
  description = "Create EC2 instance?"
}

variable "default_tags" {
  type = map(string)
  default = {
    Owner   = "DevOpsTeam"
    Project = "TerraformDemo"
  }
}
