variable "aws_key_path" {
  default="/home/gslab/.aws/terraform.pem"
}
variable "aws_key_name" {
  default="terraform-key"
}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-2"
}

variable "amis" {
    description = "AMIs by region"
    default = "ami-a95662cc"  # vThunder image
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.2.0/24"
}

