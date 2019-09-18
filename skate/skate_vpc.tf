# Define our VPC
resource "aws_vpc" "skate-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    Name = "skate-vpc"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet-skate" {
  vpc_id = "${aws_vpc.skate-vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.availability_zone_skate_1}"

  tags = {
    Name = "Skate Web Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.skate-vpc.id}"
  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "${var.availability_zone_skate_1}"

  tags = {
    Name = "Skate Database Private Subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "igw-skate" {
  vpc_id = "${aws_vpc.skate-vpc.id}"

  tags = {
    Name = "Skate VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.skate-vpc.id}"

  route {
    cidr_block = "${var.default_cidr_blocks}"
    gateway_id = "${aws_internet_gateway.igw-skate.id}"
  }

  tags = {
    Name = "Skate Public Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.public-subnet-skate.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

# Define the security group for public subnet
resource "aws_security_group" "sgweb" {
  name = "vpc_skate_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = "${var.http_port}"
    to_port = "${var.http_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.default_cidr_blocks}"]
  }

  ingress {
    from_port = "${var.https_port}"
    to_port = "${var.https_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.default_cidr_blocks}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.default_cidr_blocks}"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    to_port = "${var.ssh_port}"
    protocol = "tcp"
    cidr_blocks =  ["${var.default_cidr_blocks}"]
  }

  vpc_id="${aws_vpc.skate-vpc.id}"

  tags = {
    Name = "Skate Web Server SG"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sgdb"{
  name = "sg_skate_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = "${var.mysql_port}"
    to_port = "${var.mysql_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    to_port = "${var.ssh_port}"
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.skate-vpc.id}"

  tags = {
    Name = "Skate DB SG"
  }
}
