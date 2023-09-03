resource "aws_security_group" "bastion_server_sg" {
  name   = "${var.project_name}-${var.env}-BASTION-SERVER"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["213.32.254.232/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.env}-BASTION-SERVER"
  }
}