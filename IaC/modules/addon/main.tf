data "aws_caller_identity" "current" {}

module "hpa" {
  source               = "./hpa"
  depends-on-node-pool = var.depends-on-node-pool
  hpa-count            = var.hpa-count
}

module "hna" {
  source               = "./hna"
  depends-on-node-pool = var.depends-on-node-pool
  project_name         = var.project_name
  env                  = var.env
  region               = var.region
  cluster              = var.cluster
  cluster_name         = var.cluster_name
  hna-count            = var.hna-count
}


module "fluentd" {
  source               = "./fluentd"
  depends-on-node-pool = var.depends-on-node-pool
  fluend-count         = var.fluend-count
}

module "jaeger" {
  source               = "./jaeger"
  depends-on-node-pool = var.depends-on-node-pool
  jaeger-count         = var.jaeger-count
}

module "namespaces" {
  source               = "./namespaces"
  depends-on-node-pool = var.depends-on-node-pool
  cluster              = var.cluster
  cluster_name         = var.cluster_name
}

module "external-secrets" {
  source               = "./external-secrets"
  depends-on-node-pool = var.depends-on-node-pool
}

module "opa" {
  source               = "./opa"
  depends-on-node-pool = var.depends-on-node-pool
  opa-count            = var.opa-count
}

module "argo" {
  source                = "./argo"
  depends-on-node-pool  = var.depends-on-node-pool
  argocd-count          = var.argocd-count
  depends-on-namespaces = module.namespaces.namespaces_id
}

module "kubecost" {
  source                    = "./kubecost"
  depends-on-node-pool      = var.depends-on-node-pool
  depends-on-cluster_name   = var.cluster_name
  cluster                   = var.cluster
  cluster_name              = var.cluster_name
  eks_role_arn              = var.eks_role_arn
  kubecost_version          = var.kubecost_version
  kubecost-count            = var.kubecost-count
  depends-on-ebs-csi-driver = module.ebs_csi_driver.kube-ebs-csi
  kubecost_sa_name          = var.kubecost_sa_name
  load_balancer_dns_name    = var.load_balancer_dns_name
  project_name              = var.project_name
  kubecost_namespace        = var.kubecost_namespace
  vpc_id                    = var.vpc_id

  depends_on = [var.kubecost_sa_name]
}

module "karpenter" {
  source          = "./karpenter"
  vpc_id          = var.vpc_id
  cluster         = var.cluster
  private_subnet1 = var.private_subnet1
  private_subnet2 = var.private_subnet2
  private_subnet3 = var.private_subnet3

  public_subnet1        = var.public_subnet1
  public_subnet2        = var.public_subnet2
  public_subnet3        = var.public_subnet3
  karpenter_version     = var.karpenter_version
  karpenter_ttl         = var.karpenter_ttl
  cluster_name          = var.cluster_name
  depends-on-node-pool  = var.depends-on-node-pool
  karpenter-count       = var.karpenter-count
  karpenter_sa_name     = var.karpenter_sa_name
  karpenter_namespace   = var.karpenter_namespace
  karpenter_role_arn    = var.karpenter_role_arn
  cluster_endpoint      = var.cluster_endpoint
  instance_profile_name = var.instance_profile_name
}

module "ebs_csi_driver" {
  source                              = "./ebs_csi_driver"
  ebs-csi-count                       = var.ebs-csi-count
  depends-on-node-pool                = var.depends-on-node-pool
  ebs_csi_driver_service_account_name = var.ebs_csi_driver_service_account_name
}


module "load_balancer_controller" {
  source                           = "./lb_controller"
  depends-on-node-pool             = var.depends-on-node-pool
  cluster                          = var.cluster
  cluster_name                     = var.cluster_name
  lb-controller-count              = var.lb-controller-count
  load_balancer_controller_sa_name = var.load_balancer_controller_sa_name
  load_balancer_dns_name           = var.load_balancer_dns_name
  kubecost_service                 = module.kubecost.kubecost_service
}
