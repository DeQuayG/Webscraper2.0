variable "cluster_name" {
  type = string
}


variable "vpc_id" {
  type = string
}

variable "karpenter_version" {
  type = string
  #version                    = "0.6.3"
}

variable "karpenter_ttl" {
  type = number
}

variable "depends-on-node-pool" {
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


variable "cluster" {
  type = object({
    aws_region = string
  })
}


variable "karpenter-count" {
  type = string
}

variable "karpenter_sa_name" {

}

variable "karpenter_namespace" {

}

variable "karpenter_role_arn" {

}

variable "cluster_endpoint" {

}

variable "instance_profile_name" {

}