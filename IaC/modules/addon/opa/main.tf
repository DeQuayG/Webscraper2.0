resource "helm_release" "opa" {
  name             = "opa"
  repository       = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart            = "gatekeeper"
  namespace        = "gatekeeper"
  create_namespace = true

  depends_on = [
    var.depends-on-node-pool
  ]
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
  count = var.opa-count
}

