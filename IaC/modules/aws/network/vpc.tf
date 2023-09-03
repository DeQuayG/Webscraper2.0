resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.project_name}-${var.env}"
  }
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
}
