terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      version = "~>3.1"
    }
  }
}
provider "aws" {
  region = var.my_region
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_instance" "myec2" {
 
  ami           = var.my_ami
  instance_type = "t2.micro"
provisioner "local-exec" {
   command = "echo ${aws_instance.myec2.public_ip} > ip.txt"
}
}
resource "aws_security_group" "mysg" {
  name   = "my-sg1"
  vpc_id = var.vpc_id
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
     cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }
ingress {
     cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }
}
resource "aws_key_pair" "tf-key-pair" {
    key_name = "mytf-key"
    public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits  = 4096
}
resource "local_file" "tf-key" {
   content  = tls_private_key.rsa.private_key_pem
  filename = "mytf-key"
}
variable "my_region" {
type = string
default = "ap-south-1"
}
variable "access_key" { }
variable "secret_key" { }
variable "my_ami" {
type =  string
default = "ami-00bb6a80f01f03502"
}
