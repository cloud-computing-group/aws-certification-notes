provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "vm" {
  ami           = "ami-xxxxx"
  subnet_id     = "subnet-xxxxx"
  instance_type = "t3.micro"
  tags = {
    Name = "my-first-tf-node"
  }
}