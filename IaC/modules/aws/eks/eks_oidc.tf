data "aws_partition" "current" {}

# data "aws_eks_cluster" "eks_cluster" {
#   name = var.cluster_name

#   depends_on = [ ]
# }
data "tls_certificate" "eks_cluster" {
  url = local.formatted_oidc_issuer
  #url = "${data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer}"
}

resource "null_resource" "get_eks_oidc_info" {
  provisioner "local-exec" {
    command = <<-EOT
      oidc_info=$(aws eks describe-cluster --name ${var.cluster_name} --query "cluster.identity.oidc.issuer" --output text)
      echo "oidc_info=$oidc_info" > eks_oidc_info.txt
    EOT
  }
}

data "local_file" "eks_oidc_info" {
  filename = "${path.module}/eks_oidc_info.txt"
}

locals {
  oidc_info = {
    oidc_issuer_url = regexall("oidc_issuer_url=(.+)", data.local_file.eks_oidc_info.content)[0][0]
    client_id       = regexall("client_id=(.+)", data.local_file.eks_oidc_info.content)[0][0]
  }

  formatted_oidc_issuer = local.oidc_info.oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks_cluster" {
  client_id_list  = ["sts.amazonaws.com", "sts:AssumeRoleWithWebIdentity"]
  thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint, "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"]
  url             = local.formatted_oidc_issuer
  #url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
  #url             = https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer   #original, to fall back on just in case 

  #depends_on = [ var.depends-on-kube-prometheus ]
}

resource "aws_eks_identity_provider_config" "eks_oidc_provider_config" {
  cluster_name = var.cluster_name

  oidc {
    issuer_url                    = local.formatted_oidc_issuer
    client_id                     = local.oidc_info.client_id
    identity_provider_config_name = "OIDC-CONFIG"
  }
}


# data "aws_partition" "current" {}

# data "tls_certificate" "eks_cluster" {
#   url = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
# }

# resource "null_resource" "get_eks_oidc_info" {
#   depends_on = [aws_eks_identity_provider_config.eks_oidc_provider_config]
#   provisioner "local-exec" {
#     command = <<-EOT
#       oidc_info=$(aws eks describe-cluster --name ${var.cluster_name} --query "cluster.identity.oidc.issuer" --output text)
#       echo "oidc_info=$oidc_info" > eks_oidc_info.txt
#     EOT
#   }
# }

# data "local_file" "eks_oidc_info" {
#   filename = "${path.module}/eks_oidc_info.txt"
# }

# locals {
#   oidc_info = {
#     oidc_issuer_url = regexall("oidc_issuer_url=(.+)", data.local_file.eks_oidc_info.content)[0][0]
#     client_id       = regexall("client_id=(.+)", data.local_file.eks_oidc_info.content)[0][0]
#   }

#   formatted_oidc_issuer = local.oidc_info.oidc_issuer_url
# }

# resource "aws_iam_openid_connect_provider" "eks_cluster" {
#   client_id_list  = ["sts.amazonaws.com", "sts:AssumeRoleWithWebIdentity"]
#   thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint, "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"]
#   url             = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"

#   depends_on = [aws_eks_identity_provider_config.eks_oidc_provider_config, var.cluster]
# }

# resource "aws_eks_identity_provider_config" "eks_oidc_provider_config" {
#   cluster_name = var.cluster_name

#   oidc {
#     issuer_url                    = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
#     client_id                     = local.oidc_info.client_id
#     identity_provider_config_name = "OIDC-CONFIG"
#   }
#   depends_on = [ var.cluster ]
# }











# data "aws_partition" "current" {}


# data "tls_certificate" "eks_cluster" {
#   url = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
#   #url = "${data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer}"
# }

# resource "null_resource" "get_eks_oidc_info" {

#   depends_on = [aws_eks_identity_provider_config.eks_oidc_provider_config]
#   provisioner "local-exec" {
#     command = <<-EOT
#       oidc_info=$(aws eks describe-cluster --name ${var.cluster_name} --query "cluster.identity.oidc.issuer" --output text)
#       echo "oidc_info=$oidc_info" > eks_oidc_info.txt
#     EOT
#   }
# }

# data "local_file" "eks_oidc_info" {
#   filename = "${path.module}/eks_oidc_info.txt"
# }

# locals {
#   oidc_info = {
#     oidc_issuer_url = regexall("oidc_issuer_url=(.+)", data.local_file.eks_oidc_info.content)[0][0]
#     client_id       = regexall("client_id=(.+)", data.local_file.eks_oidc_info.content)[0][0]
#   }

#   formatted_oidc_issuer = local.oidc_info.oidc_issuer_url
# }

# resource "aws_iam_openid_connect_provider" "eks_cluster" {
#   client_id_list  = ["sts.amazonaws.com", "sts:AssumeRoleWithWebIdentity"]
#   thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint, "9E99A48A9960B14926BB7F3B02E22DA2B0AB7280"]
#   url             = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
#   #url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
#   #url             = https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer   #original, to fall back on just in case 

#   #depends_on = [ var.depends-on-kube-prometheus ]
# }

# resource "aws_eks_identity_provider_config" "eks_oidc_provider_config" {
#   cluster_name = var.cluster_name

#   oidc {
#     issuer_url                    = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
#     client_id                     = local.oidc_info.client_id
#     identity_provider_config_name = "OIDC-CONFIG"
#   }

#   depends_on = [ 
#     aws_iam_openid_connect_provider.eks_cluster,
#    ]
# }


# resource "aws_iam_openid_connect_provider" "eks_cluster" {
#   client_id_list   = ["sts.amazonaws.com"]
#   thumbprint_list  = []
#   url              = "https://oidc.eks.${var.aws_region}.amazonaws.com/id/${var.cluster_name}/identity/oidc/issuer"
# }


