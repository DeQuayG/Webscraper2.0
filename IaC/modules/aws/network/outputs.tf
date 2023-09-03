output "vpc_id" {
  value = aws_vpc.example.id
}

output "vpc_cidr" {
  value = aws_vpc.example.cidr_block
}

output "private_subnet1" {
  value = aws_subnet.private1.id
}

output "private_subnet2" {
  value = aws_subnet.private2.id
}

output "private_subnet3" {
  value = aws_subnet.private3.id
}

output "public_subnet1" {
  value = aws_subnet.public1.id
}

output "public_subnet2" {
  value = aws_subnet.public2.id
}

output "public_subnet3" {
  value = aws_subnet.public3.id
}

output "load_balancer_dns_name" {
  value = aws_lb.eks_lb.name
}