variable "aws_region" {
  description = "Region for the Skate VPC"
  default = "eu-west-2"
}

variable "vpc_cidr" {
  description = "CIDR for the Skate VPC"
  default = "11.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public Skate subnet"
  default = "11.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private Skate subnet"
  default = "11.0.2.0/24"
}

variable "default_cidr_blocks"{
  description = "CIDR for default subnet"
  default = "0.0.0.0/0"
}

variable "availability_zone_skate_1" {
  description = "Availability zone 1"
  default = "eu-west-2c"
}

variable "http_port" {
  description = "Port HTTP"
  default = "80"
}

variable "https_port" {
  description = "Port HTTPS"
  default = "443"
}

variable "ssh_port" {
  description = "Port SSH"
  default = "22"
}

variable "mysql_port" {
  description = "Port MySQL"
  default = "3306"
}

#variable "ami" {
#  description = "AMI Public Windows for EC2"
#  default = "ami-4fffc834"
#}

#variable "key_path" {
#  description = "SSH Public Key path"
#  default = "/path/to/key/id_rsa.pub"
#}
