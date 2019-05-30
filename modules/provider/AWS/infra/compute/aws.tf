variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-2"
}

variable "my_profile" {
  default="gslab"
}



provider "aws" {
    #access_key = "${var.aws_access_key}"
    #secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
    #profile= "${var.my_profile}"
}
