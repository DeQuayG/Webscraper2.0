variable "env" {
  type = string
}

variable "project_name" {
  type = string
}

variable "public_key_name" {
  type = string
}

variable "bastion_ami" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}
variable "bastion_subnet_id" {
  type = string
}

variable "bastion_server_sg_id" {
  type = string
}