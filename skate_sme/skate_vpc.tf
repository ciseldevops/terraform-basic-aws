# Define our VPC // VPC with public/private subnets across multiple AZs with Internet Gateways
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "skate-vpc-sme"
  cidr = "10.0.0.0/16"
  enable_dns_hostnames = true

  azs             = ["eu-west-2c", "eu-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Name = "skate-vpc-sme"
    Terraform = "true"
    Environment = "dev"
  }
}

# Define the route table
#resource "aws_route_table" "web-public-rt" {
#  vpc_id = "${vpc_id}"
#
#  route {
#    cidr_block = "${var.default_cidr_blocks}"
#    gateway_id = "${aws_internet_gateway.igw-skate.id}"
#  }
#
#  tags = {
#    Name = "Skate Public Subnet RT"
#  }
#}

# Assign the route table to the public Subnet
#resource "aws_route_table_association" "web-public-rt" {
#  subnet_id = "${aws_subnet.public-subnet-skate.id}"
#  route_table_id = "${aws_route_table.web-public-rt.id}"
#}

# Define the security group for public subnet
module "sg_web" {
  source = "terraform-aws-modules/security-group/aws"
  name = "sg_skate_web_sg"
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
module "sg_db" {
  source = "terraform-aws-modules/security-group/aws"

  name = "sg_skate_db_sg"
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
