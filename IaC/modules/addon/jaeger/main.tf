resource "helm_release" "jaeger" {
  name             = "jaeger-tracing"
  repository       = "https://jaegertracing.github.io/helm-charts"
  chart            = "jaeger"
  namespace        = "jaeger"
  create_namespace = true

  set {
    name  = "manager.securityContext.allowPrivilegeEscalation"
    value = false
  }
  set {
    name  = "manager.securityContext.capabilities.drop[0]"
    value = "ALL"
  }
  set {
    name  = "manager.securityContext.runAsNonRoot"
    value = true
  }
  set {
    name  = "manager.securityContext.seccompProfile.type"
    value = "Localhost"
  }

  depends_on = [
    var.depends-on-node-pool,
  ]

  count = var.jaeger-count
}
