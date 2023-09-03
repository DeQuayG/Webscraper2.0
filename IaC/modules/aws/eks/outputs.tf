output "cluster-worker-node-id" {
  value = aws_eks_node_group.tools_node_group.id
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "cluster_name_arn" {
  value = aws_eks_cluster.eks_cluster.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks_cluster.arn
}

output "oidc_client_id" {
  value = local.oidc_info.client_id
}

output "oidc_issuer_url" {
  value = local.formatted_oidc_issuer
}

output "apps_group" {
  value = aws_eks_node_group.apps_node_group.node_group_name
}

output "tools_group" {
  value = aws_eks_node_group.tools_node_group.node_group_name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}