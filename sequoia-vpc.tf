terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.60.0"
    }
  }
}

# Configure the AWS Provider (remove duplicate)
provider "aws" {
  alias  = "vpc"
  region = "us-east-1"
}

# Fetch availability zones
data "aws_availability_zones" "availability_zone" {
  state = "available"
}

# Create VPC; CIDR 10.0.0.0/16
resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = true
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "Name" = "${var.default_tags.env}-VPC"
  }
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "All in"
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    self        = true
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound Rules
  egress {
    description = "Allow All"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#  Public Subnet: cidr 10.0.0.0/24
#                 cidr 10.0.1.0/24
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)      # prefix, newbtis, netnum
  ipv6_cidr_block         = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index) # prefix, newbtis, netnum
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.default_tags.env}-Public-Subnet-${data.aws_availability_zones.availability_zone.names[count.index]}" #terraform_testing-Public-Subnet-AZ}"
  }
  availability_zone = data.aws_availability_zones.availability_zone.names[count.index] # specifying the AZ the subnet is in
}

#  Private Subnet: cidr 10.0.2.0/24
#                  cidr 10.0.3.0/24
resource "aws_subnet" "private" {
  count      = var.private_subnet_count
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + var.public_subnet_count) # prefix, newbtis, netnum

  tags = {
    "Name" = "${var.default_tags.env}-Private-Subnet-${data.aws_availability_zones.availability_zone.names[count.index]}"
  }
  availability_zone = data.aws_availability_zones.availability_zone.names[count.index] # specifying the AZ the subnet is in
}

# IGW
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id #attachement

  tags = {
    "Name" = "${var.default_tags.env}-IGW"
  }
}

# EIP
resource "aws_eip" "NAT_EIP" {
  vpc = true
  tags = {
    Name = "Sequoia-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.NAT_EIP.id
  subnet_id     = aws_subnet.public.0.id
  tags = {
    "Name" = "${var.default_tags.env}-nat"
  }
}

# Public RT
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.env}-Public-rt"
  }
}

# Route for our public rt
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# Route Table associations
resource "aws_route_table_association" "public-rt" {
  route_table_id = aws_route_table.public-rt.id
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.public.*.id, count.index) # list, index
}

# Private Route Table
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.default_tags.env}-Private-RT"
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "private" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}


resource "aws_route_table_association" "private2" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}

# Naming Elastic IP
resource "aws_eip" "elastic_ip" {
  tags = {
    Name = "Sequoia-eip"
  }
}