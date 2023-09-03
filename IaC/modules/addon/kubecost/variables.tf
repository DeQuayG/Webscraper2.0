variable "depends-on-node-pool" {
  type = string
}

variable "depends-on-cluster_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster" {
  type = object({
    aws_region = string
  })
}

variable "eks_role_arn" {
  type = string
}

variable "kubecost_version" {
  type = string
}

variable "kubecost-count" {
  type = string
}

variable "depends-on-ebs-csi-driver" {
}


variable "kubecost_sa_name" {

}

variable "load_balancer_dns_name" {
}

variable "project_name" {

}

variable "kubecost_namespace" {

}

variable "vpc_id" {

}