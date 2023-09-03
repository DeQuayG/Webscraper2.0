output "kubecost_service" {
  value = helm_release.kubecost[0].name
}