output "eks_nodes_role_arn" {
  value = aws_iam_role.eks_nodes_role.arn
}

output "eks_role_arn" {
  value = aws_iam_role.eks_role.arn
}

output "ebs_role_arn" {
  value = aws_iam_role.ebs_csi_driver_role.arn
}

output "ebs_csi_driver_service_account_name" {
  value = kubernetes_service_account.ebs_csi_driver_sa.metadata[0].name
}

output "kubecost_sa_name" {
  value = kubernetes_service_account.kubecost_cost_analyzer_sa.metadata[0].name
}


output "karpenter_sa_name" {
  value = kubernetes_service_account.karpenter_sa.metadata[0].name
}


output "load_balancer_controller_sa_name" {
  value = kubernetes_service_account.load_balancer_controller_sa.metadata[0].name
}

output "prometheus_sa_name" {
  value = kubernetes_service_account.prometheus_sa.metadata[0].name
}

output "eks_cluster_policy" {
  value = aws_iam_role_policy_attachment.eks_cluster_policy
}

output "eks_worker_node_policy" {
  value = aws_iam_role_policy_attachment.eks_worker_node_policy
}

output "eks_cni_policy" {
  value = aws_iam_role_policy_attachment.eks_cni_policy
}


output "prometheus_namespace" {
  value = kubernetes_namespace.prometheus_namespace

}


output "karpenter_role_arn" {
  value = aws_iam_role.karpenter_role.arn

}

output "kubecost_namespace" {
  value = kubernetes_namespace.kubecost_namespace

}

output "instance_profile_name" {
  value = aws_iam_instance_profile.karpenter_ip.name

}

