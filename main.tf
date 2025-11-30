terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -----------------------
# VPC
# -----------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-vpc-${var.env}"
    }
  )
}

# -----------------------
# Subnets using cidrsubnet()
# -----------------------
resource "aws_subnet" "subnets" {
  count                   = length(var.subnet_numbers)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, var.subnet_numbers[count.index])
  availability_zone       = var.azs[count.index]

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-subnet-${count.index + 1}-${var.env}"
    }
  )
}

# -----------------------
# EC2 Instance (conditional)
# -----------------------
resource "aws_instance" "ec2" {
  count         = var.create_ec2 ? 1 : 0
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnets[0].id

  tags = merge(
    var.default_tags,
    {
      Name = "${var.project_name}-ec2-${var.env}"
    }
  )
}

# -----------------------
# S3 Bucket
# -----------------------
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-bucket-${var.env}-${random_id.bucket_id.hex}"

  tags = merge(
    var.default_tags,
    {
      Environment = var.env
    }
  )
}

resource "random_id" "bucket_id" {
  byte_length = 2
}
