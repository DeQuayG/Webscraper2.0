resource "aws_eks_node_group" "tools_node_group" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  node_group_name = "${var.project_name}-${var.env}_NODE-GROUPS"

  node_role_arn = var.eks_nodes_role_arn

  subnet_ids = [
    var.private_subnet1,
    var.private_subnet2,
    var.private_subnet3,
  ]

  scaling_config {
    desired_size = var.cluster["desired_size"]
    max_size     = var.cluster["max_size_default"]
    min_size     = var.cluster["min_size_default"]
  }

  ami_type = var.cluster["ami_id"]

  capacity_type = var.cluster["capacity_type"]

  disk_size = var.cluster["disk_size"]

  instance_types = var.cluster["instance_types"]

  labels = {
    role = "k8a-tools"
  }

  version = "1.27"

  depends_on = [
    var.eks_worker_node_policy,
    var.eks_cni_policy
  ]
}

resource "aws_eks_node_group" "apps_node_group" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  node_group_name = "${var.project_name}-${var.env}_APPS-NODE-GROUPS"

  node_role_arn = var.eks_nodes_role_arn

  subnet_ids = [
    var.private_subnet1,
    var.private_subnet2,
    var.private_subnet3,
  ]

  taint {
    key    = "ENV"
    value  = "APP"
    effect = "NO_SCHEDULE"
  }

  scaling_config {
    # desired_size = var.cluster["desired_size"]
    desired_size = var.cluster["desired_size_apps"]
    max_size     = var.cluster["max_size_apps"]
    min_size     = var.cluster["min_size_apps"]
  }

  ami_type = var.cluster["ami_id"]

  capacity_type = var.cluster["capacity_type"]

  disk_size = var.cluster["disk_size_apps"]

  instance_types = var.cluster["instance_types_apps"]

  labels = {
    role = "eks-apps-node-groups"
  }

  version = "1.27"

  depends_on = [
    var.eks_worker_node_policy,
    var.eks_cni_policy
  ]
}