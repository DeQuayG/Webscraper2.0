resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.example.id
  availability_zone       = "${var.cluster["aws_region"]}b"
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet1_cidr_block
  tags = {
    Name                                                   = "${var.project_name}-PRIVATE-${var.env}"
    "kubernetes.io/cluster/${var.project_name}-${var.env}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.example.id
  availability_zone       = "${var.cluster["aws_region"]}a"
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet2_cidr_block
  tags = {
    Name                                                   = "${var.project_name}-PRIVATE2-${var.env}"
    "kubernetes.io/cluster/${var.project_name}-${var.env}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.example.id
  availability_zone       = "${var.cluster["aws_region"]}c"
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnet3_cidr_block
  tags = {
    Name                                                   = "${var.project_name}-PRIVATE3-${var.env}"
    "kubernetes.io/cluster/${var.project_name}-${var.env}" = "shared"
    "kubernetes.io/role/internal-elb"                      = "1"
  }
}
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.public_subnet1_cidr_block
  availability_zone       = "${var.cluster["aws_region"]}a"
  map_public_ip_on_launch = true
  tags = {
    Name                                                   = "${var.project_name}-PUBLIC-${var.env}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${var.project_name}-${var.env}" = "shared"
  }
}
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.public_subnet2_cidr_block
  availability_zone       = "${var.cluster["aws_region"]}b"
  map_public_ip_on_launch = true
  tags = {
    Name                                                   = "${var.project_name}-PUBLIC2-${var.env}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${var.project_name}-${var.env}" = "shared"
  }
}


resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.public_subnet3_cidr_block
  availability_zone       = "${var.cluster["aws_region"]}c"
  map_public_ip_on_launch = true
  tags = {
    Name                                                   = "${var.project_name}-PUBLIC3-${var.env}"
    "kubernetes.io/role/elb"                               = "1"
    "kubernetes.io/cluster/${var.project_name}-${var.env}" = "shared"
  }
}
