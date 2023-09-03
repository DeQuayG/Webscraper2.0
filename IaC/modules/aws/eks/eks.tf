resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.cluster_name
  role_arn                  = var.eks_role_arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  version                   = "1.27"


  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }
  vpc_config {
    public_access_cidrs = var.public_access_cidrs

    endpoint_public_access = true

    subnet_ids = [
      var.public_subnet1,
      var.public_subnet2,
      var.public_subnet3,

      var.private_subnet1,
      var.private_subnet2,
      var.private_subnet3,
    ]
  }

  depends_on = [
    var.eks_cluster_policy
  ]

  provisioner "local-exec" {
    command = <<EOT
      aws eks --region ${var.cluster["aws_region"]} update-kubeconfig --name ${self.name}
    EOT
  }
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name       = aws_eks_cluster.eks_cluster.name
  depends_on = [aws_eks_cluster.eks_cluster]
}
