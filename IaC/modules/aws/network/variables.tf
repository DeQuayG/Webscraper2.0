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
variable "env" {
  type = string
}
variable "project_name" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet1_cidr_block" {
  type = string
}

variable "public_subnet2_cidr_block" {
  type = string
}

variable "public_subnet3_cidr_block" {
  type = string
}

variable "private_subnet1_cidr_block" {
  type = string
}

variable "private_subnet2_cidr_block" {
  type = string
}

variable "private_subnet3_cidr_block" {
  type = string
}

variable "public_access_cidrs" {

}

variable "tools_group" {

}

variable "apps_group" {

}
