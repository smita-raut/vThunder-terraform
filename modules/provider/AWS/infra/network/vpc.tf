resource "aws_vpc" "vpc01" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "terraform-aws-vpc"
    }
}

resource "aws_internet_gateway" "terraform_default" {
    vpc_id = "${aws_vpc.vpc01.id}"
}

/*
  Public Subnet
*/
resource "aws_subnet" "us-east-2a-public" {
    vpc_id = "${aws_vpc.vpc01.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-east-2a"
    map_public_ip_on_launch= "true"

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table" "us-east-2a-public" {
    vpc_id = "${aws_vpc.vpc01.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.terraform_default.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "us-east-2a-public" {
    subnet_id = "${aws_subnet.us-east-2a-public.id}"
    route_table_id = "${aws_route_table.us-east-2a-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-east-2a-private" {
    vpc_id = "${aws_vpc.vpc01.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "us-east-2a"

    tags {
        Name = "Private Subnet"
    }
}



resource "aws_security_group" "test_sg" {
  name = "test_sg"
  vpc_id = "${aws_vpc.vpc01.id}"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow outgoing traffic to anywhere.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "default" {
  subnet_id       = "${aws_subnet.us-east-2a-public.id}"
  #private_ips     = ["10.0.1.15"]
  security_groups = ["${aws_security_group.test_sg.id}"]
  tags {
    "TAG" = "default"
  }
}


resource "aws_network_interface" "test" {
  subnet_id       = "${aws_subnet.us-east-2a-private.id}"
  private_ips     = ["10.0.2.15", "10.0.2.16"]
  security_groups = ["${aws_security_group.test_sg.id}"]

  attachment {
    instance     = "${aws_instance.centos-vm01.id}"
    device_index = 1
  }
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = "${aws_network_interface.test.id}"
  associate_with_private_ip = "10.0.2.15"
}
resource "aws_eip" "two" {
  vpc                       = true
  network_interface         = "${aws_network_interface.test.id}"
  associate_with_private_ip = "10.0.2.16"

}

resource "aws_eip" "three" {
    vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  network_interface_id   = "${aws_network_interface.default.id}"
  allocation_id = "${aws_eip.three.id}"

}
