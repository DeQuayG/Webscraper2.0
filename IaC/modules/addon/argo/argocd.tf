resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo"
  create_namespace = true
  cleanup_on_fail  = true
  # version         = "3.29.4"

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
    type  = "string"
  }

  depends_on = [
    var.depends-on-node-pool,
    var.depends-on-namespaces
  ]

  count = var.argocd-count
}

