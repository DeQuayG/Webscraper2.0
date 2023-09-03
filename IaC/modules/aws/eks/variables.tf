variable "env" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_access_cidrs" {

  type = list(any)
}

variable "project_name" {
  type = string
}

variable "cluster" {
  type = object({
    capacity_type       = string
    desired_size        = number
    desired_size_apps   = number
    max_size_default    = number
    min_size_default    = number
    max_size_apps       = number
    min_size_apps       = number
    disk_size           = number
    disk_size_apps      = number
    ami_id              = string
    instance_types      = list(string)
    instance_types_apps = list(string)
    aws_region          = string
  })
}

variable "eks_role_arn" {
  type = string
}

variable "private_subnet1" {
  type = string
}

variable "private_subnet2" {
  type = string
}

variable "private_subnet3" {
  type = string
}

variable "public_subnet1" {
  type = string
}

variable "public_subnet2" {
  type = string
}

variable "public_subnet3" {
  type = string
}


variable "eks_nodes_role_arn" {
  type = string
}

variable "eks_cluster_policy" {
}

variable "eks_worker_node_policy" {
}

variable "eks_cni_policy" {
}

variable "cluster_name" {

}
