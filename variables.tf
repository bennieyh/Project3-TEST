
variable "default_tags" {
  type = map(string)
  default = {
    "env" = "Sequoia"
  }
  description = "Sequoia variables decsription"
}

variable "sg_name" {
  type        = string
  description = "Name of the security group"
  default     = "Sequoia-security-group"
}

variable "description" {
  type        = string
  description = "Sequoia-Des"
  default     = "Sequioa-Proj3"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
  default     = "Sequioa-VPC"
}

variable "sg_db_ingress" {
  type = list(object({
    port     = number
    protocol = string
    self     = bool
  }))
  description = "Ingress rules for the security group"
  default     = []
}

variable "sg_db_egress" {
  type = list(object({
    port     = number
    protocol = string
    self     = bool
  }))
  description = "Egress rules for the security group"
  default     = []
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_subnet_count" {
  type        = number
  description = "default"
  default     = 2
}

variable "private_subnet_count" {
  type        = number
  description = "private subnet count description"
  default     = 2
}
