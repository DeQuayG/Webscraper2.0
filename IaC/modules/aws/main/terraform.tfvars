ubuntu_ami                    = "ami-0767046d1677be5a0"
env                           = "DEV"
bastion_ami                   = "ami-083654bd07b5da81d"
bastion_instance_type         = "t2.micro"
project_name                  = "EXAMPLE"
account_name                  = "test"
identity_provider_config_name = "eks_oidc"
cluster_name                  = "EXAMPLE-DEV" # <PROJECT_NAME>-<ENV>
karpenter_namespace           = "karpenter"
kubecost_namespace            = "kubecost"

cluster = {
  capacity_type       = "ON_DEMAND"
  desired_size        = 2
  desired_size_apps   = 2
  max_size_apps       = 3
  min_size_apps       = 1
  max_size_default    = 3
  min_size_default    = 1
  disk_size           = 60
  disk_size_apps      = 60
  ami_id              = "AL2_x86_64"
  instance_types      = ["t3.xlarge"]
  instance_types_apps = ["t3.xlarge"]
  aws_region          = "us-east-1"
}



# Network variables
public_access_cidrs        = ["0.0.0.0/0"]
vpc_cidr_block             = "10.1.0.0/16"
public_subnet1_cidr_block  = "10.1.2.0/24"
public_subnet2_cidr_block  = "10.1.3.0/24"
public_subnet3_cidr_block  = "10.1.6.0/24"
private_subnet1_cidr_block = "10.1.1.0/24"
private_subnet2_cidr_block = "10.1.4.0/24"
private_subnet3_cidr_block = "10.1.5.0/24"


# kubernates deployment services
# mark it 1 to deploy 0 not to deploy
prometheus-count    = 0
hpa-count           = 1
hna-count           = 1
fluend-count        = 1
jaeger-count        = 1
conjur-count        = 1
argocd-count        = 1
kubecost-count      = 1
karpenter-count     = 1
opa-count           = 0
ebs-csi-count       = 1
lb-controller-count = 1