resource "helm_release" "hpa" {
  name            = "hpa"
  repository      = "https://charts.bitnami.com/bitnami"
  chart           = "wavefront-hpa-adapter"
  namespace       = "default"
  version         = "1.5.2"
  cleanup_on_fail = true

  depends_on = [
    var.depends-on-node-pool
  ]

  count = var.hpa-count
}