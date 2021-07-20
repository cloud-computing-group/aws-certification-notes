#declare provider
provider "aws" {}

#Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      "Name" = "master-vpc-jenkins"
    }
}
