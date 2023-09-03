variable "depends-on-node-pool" {

}

variable "lb-controller-count" {

}

variable "cluster_name" {

}

variable "cluster" {
  type = object({
    aws_region = string
  })
}

variable "load_balancer_controller_sa_name" {

}

variable "load_balancer_dns_name" {

}

variable "kubecost_service" {

}
