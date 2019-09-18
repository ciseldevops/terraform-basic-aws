provider "aws" {
 version = "~> 2.28"
 shared_credentials_file = "~/.aws/credentials"
 profile                 = "terraform"
 region = "${var.aws_region}"
}
