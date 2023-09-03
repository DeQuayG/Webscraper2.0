resource "aws_instance" "example_bastion_server" {
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
  key_name      = var.public_key_name

  subnet_id = var.bastion_subnet_id

  vpc_security_group_ids = [var.bastion_server_sg_id]
  tags = {
    Name = "${var.project_name}-${var.env}-BASTION-SERVER"
  }


}