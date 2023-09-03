data "aws_caller_identity" "current" {}

module "network" {
  source                     = "../network"
  cluster                    = var.cluster
  env                        = var.env
  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet1_cidr_block  = var.public_subnet1_cidr_block
  public_subnet2_cidr_block  = var.public_subnet2_cidr_block
  public_subnet3_cidr_block  = var.public_subnet3_cidr_block
  private_subnet1_cidr_block = var.private_subnet1_cidr_block
  private_subnet2_cidr_block = var.private_subnet2_cidr_block
  private_subnet3_cidr_block = var.private_subnet3_cidr_block
  project_name               = var.project_name
  public_access_cidrs        = var.public_access_cidrs
  tools_group                = module.eks.apps_group
  apps_group                 = module.eks.tools_group
}

module "security" {
  source                         = "../security"
  env                            = var.env
  vpc_cidr_block                 = var.vpc_cidr_block
  vpc_id                         = module.network.vpc_id
  project_name                   = var.project_name
  cluster_name                   = var.cluster_name
  cluster                        = var.cluster
  depends-on-node-pool           = module.eks.cluster-worker-node-id
  aws_region                     = var.cluster.aws_region
  aws_caller_identity_account_id = data.aws_caller_identity.current
}


module "iam" {
  source = "../iam"

  depends-on-node-pool           = module.eks.cluster-worker-node-id
  aws_region                     = var.cluster.aws_region
  aws_caller_identity_account_id = data.aws_caller_identity.current
  oidc_client_id                 = module.eks.oidc_client_id
  oidc_provider_arn              = module.eks.oidc_provider_arn
  env                            = var.env
  vpc_cidr_block                 = var.vpc_cidr_block
  vpc_id                         = module.network.vpc_id
  project_name                   = var.project_name
  cluster_name                   = var.cluster_name
  cluster_name_arn               = module.eks.cluster_name_arn
  cluster                        = var.cluster
  kubecost_namespace             = var.kubecost_namespace
  karpenter_namespace            = var.karpenter_namespace
}



module "operations" {
  source = "../ops"
  env    = var.env

  public_key_name       = module.security.public_key_name
  bastion_ami           = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type
  bastion_subnet_id     = module.network.public_subnet1
  bastion_server_sg_id  = module.security.bastion_server_sg_id
  project_name          = var.project_name
}


module "eks" {
  source       = "../eks"
  env          = var.env
  aws_region   = var.cluster.aws_region
  cluster      = var.cluster
  cluster_name = var.cluster_name

  vpc_cidr_block = module.network.vpc_cidr
  vpc_id         = module.network.vpc_id

  private_subnet1 = module.network.private_subnet1
  private_subnet2 = module.network.private_subnet2
  private_subnet3 = module.network.private_subnet3

  public_subnet1 = module.network.public_subnet1
  public_subnet2 = module.network.public_subnet2
  public_subnet3 = module.network.public_subnet3

  eks_role_arn           = module.iam.eks_role_arn
  eks_nodes_role_arn     = module.iam.eks_nodes_role_arn
  eks_cluster_policy     = module.iam.eks_cluster_policy
  eks_worker_node_policy = module.iam.eks_worker_node_policy
  eks_cni_policy         = module.iam.eks_cni_policy
  project_name           = var.project_name
  public_access_cidrs    = var.public_access_cidrs
}

module "addon" {
  source                              = "../../addon"
  depends-on-node-pool                = module.eks.cluster-worker-node-id
  env                                 = var.env
  region                              = var.cluster["aws_region"]
  cluster                             = var.cluster
  cluster_name                        = var.cluster_name
  project_name                        = var.project_name
  prometheus-count                    = var.prometheus-count
  hpa-count                           = var.hpa-count
  hna-count                           = var.hna-count
  fluend-count                        = var.fluend-count
  jaeger-count                        = var.jaeger-count
  argocd-count                        = var.argocd-count
  opa-count                           = var.opa-count
  karpenter-count                     = var.karpenter-count
  kubecost-count                      = var.kubecost-count
  ebs-csi-count                       = var.ebs-csi-count
  eks_role_arn                        = module.iam.eks_role_arn
  ebs_csi_driver_service_account_name = module.iam.ebs_csi_driver_service_account_name
  kubecost_sa_name                    = module.iam.kubecost_sa_name
  karpenter_sa_name                   = module.iam.karpenter_sa_name
  load_balancer_controller_sa_name    = module.iam.load_balancer_controller_sa_name
  prometheus_sa_name                  = module.iam.prometheus_sa_name
  vpc_id                              = module.network.vpc_id
  private_subnet1                     = module.network.private_subnet1
  private_subnet2                     = module.network.private_subnet2
  private_subnet3                     = module.network.private_subnet3

  public_subnet1         = module.network.public_subnet1
  public_subnet2         = module.network.public_subnet2
  public_subnet3         = module.network.public_subnet3
  load_balancer_dns_name = module.network.load_balancer_dns_name
  lb-controller-count    = var.lb-controller-count
  karpenter_namespace    = var.karpenter_namespace
  kubecost_namespace     = var.kubecost_namespace
  karpenter_role_arn     = module.iam.karpenter_role_arn
  cluster_endpoint       = module.eks.cluster_endpoint
  instance_profile_name  = module.iam.instance_profile_name

}



##### IRSA ########


module "vpc_cni_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "vpc-cni"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/https://oidc.eks.${var.cluster.aws_region}.amazonaws.com/id/${module.eks.oidc_client_id}"
      namespace_service_accounts = ["default:eks-sa", "kube-system:eks-sa"]
    }
  }
}

# module "karpenter_irsa_role" {
#   source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name                          = "karpenter_controller"
#   attach_karpenter_controller_policy = true

#   karpenter_controller_cluster_name       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/https://oidc.eks.${var.cluster.aws_region}.amazonaws.com/id/${module.eks.oidc_client_id}"
#   karpenter_controller_node_iam_role_arns = [module.iam.eks_nodes_role_arn]

#   attach_vpc_cni_policy = true
#   vpc_cni_enable_ipv4   = true

#   oidc_providers = {
#     main = {
#       provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/https://oidc.eks.${var.cluster.aws_region}.amazonaws.com/id/${module.eks.oidc_client_id}"
#       namespace_service_accounts = ["default:eks-sa", "kubecost-karpenter:kubcost-karpenter-sa", "kube-system:kube-sa"]
#     }
#   }
# }


