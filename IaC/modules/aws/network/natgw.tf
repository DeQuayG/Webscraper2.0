resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id
  tags = {
    Name = "${var.project_name}-${var.env}"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "${var.project_name}-${var.env}"
  }
}
