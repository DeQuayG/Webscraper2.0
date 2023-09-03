output "public_key_name" {
  value = aws_key_pair.public_key_pair.key_name
}

output "bastion_server_sg_id" {
  value = aws_security_group.bastion_server_sg.id
}

output "postgresql_sg_id" {
  value = aws_security_group.postgresql_sg.id
}