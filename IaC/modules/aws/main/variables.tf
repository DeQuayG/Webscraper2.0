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

variable "ubuntu_ami" {
  type = string
}

variable "project_name" {
  type = string
}

variable "env" {
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

variable "bastion_ami" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "public_access_cidrs" {

  type = list(any)
}

variable "fluend-count" {
  type = string
}

variable "hna-count" {
  type = string
}

variable "hpa-count" {
  type = string
}

variable "jaeger-count" {
  type = string
}

variable "prometheus-count" {
  type = string
}

variable "argocd-count" {
  type = string
}

variable "kubecost-count" {
  type = string
}

variable "karpenter-count" {
  type = string
}

variable "opa-count" {
  type = string
}

variable "ebs-csi-count" {
  type = string
}

variable "lb-controller-count" {

}

variable "cluster_name" {

}

variable "kubecost_namespace" {

}

variable "karpenter_namespace" {

}
