provider "aws" {
  region = "us-east-1"
}

#resource "aws_vpc" "main" {
#  cidr_block = "10.0.0.0/16"
#}

#resource "aws_subnet" "private" {
#  vpc_id                  = aws_vpc.main.id
#  cidr_block              = "10.0.1.0/24"
#  availability_zone       = "us-east-1a"
#}

resource "aws_security_group" "main" {
  name        = var.sg_name
  description = var.description != null ? var.description : "Sequoia-SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

