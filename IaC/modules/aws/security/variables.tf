variable "env" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "project_name" {
  type = string
}

variable "cluster" {
  type = object({
    aws_region = string
  })
}

variable "cluster_name" {
  type = string
}

variable "depends-on-node-pool" {
  type = string
}

variable "aws_caller_identity_account_id" {
}

variable "aws_region" {
  type = string
}
