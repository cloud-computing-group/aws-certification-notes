# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

## Create an Instance
resource "aws_instance" "example_ec2" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}