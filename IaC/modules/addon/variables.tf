variable "depends-on-node-pool" {
  type = string
}

variable "cluster" {
  type = object({
    aws_region = string
  })
}

variable "env" {
  type = string
}
variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "project_name" {
  type = string
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

variable "eks_role_arn" {
  type = string
}

variable "ebs_csi_driver_service_account_name" {
}

variable "vpc_id" {
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

variable "karpenter_version" {
  type    = string
  default = "v0.16.0"
}

variable "karpenter_ttl" {
  type    = number
  default = 1800
}

variable "kubecost_version" {
  type    = string
  default = "1.104.5"
}

variable "kubecost_sa_name" {
}

variable "karpenter_sa_name" {
}

variable "load_balancer_controller_sa_name" {

}


variable "load_balancer_dns_name" {
}

variable "karpenter_namespace" {

}

variable "kubecost_namespace" {

}

variable "prometheus_sa_name" {

}

variable "karpenter_role_arn" {

}

variable "cluster_endpoint" {

}

variable "instance_profile_name" {

}

variable "lb-controller-count" {

}