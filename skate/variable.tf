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

variable "availability_zone_skate_1" {
  description = "Availability zone 1"
  default = "eu-west-2c"
}

#variable "ami" {
#  description = "AMI for EC2"
#  default = "ami-4fffc834"
#}

#variable "key_path" {
#  description = "SSH Public Key path"
#  default = "/home/core/.ssh/id_rsa.pub"
#}
