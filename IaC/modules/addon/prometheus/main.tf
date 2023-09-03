# resource "helm_release" "prometheus" {
#   name       = "kube-prometheus"
#   repository = "oci://registry-1.docker.io/bitnamicharts"
#   chart      = "kube-prometheus"
#   namespace  = "prometheus"
#   atomic = true
#   #version         = "8.15.2"
#   cleanup_on_fail  = true
#   create_namespace = false

#   set {
#     name  = "JAEGER_AGENT_PORT"
#     value = "5755"
#     type  = "string"
#   }

#   set {
#     name  = "manager.securityContext.allowPrivilegeEscalation"
#     value = false
#   }
#   set {
#     name  = "manager.securityContext.capabilities.drop[0]"
#     value = "ALL"
#   }
#   set {
#     name  = "manager.securityContext.runAsNonRoot"
#     value = true
#   }
#   set {
#     name  = "manager.securityContext.seccompProfile.type"
#     value = "Localhost"
#   }

#   set {
#     name  = "serviceAccountName"
#     value = var.prometheus_sa_name
#   }

#   set {
#     name = "prometheus.prometheusSpec.additionalScrapeConfigs"
#     value = yamlencode([{"job_name": "kubecost\nhonor_labels: true\nscrape_interval: 1m\nscrape_timeout: 10s\nmetrics_path: /metrics\nscheme: http\ndns_sd_configs:\n- names:\n — kubecost-cost-analyzer.kubecost\n type: 'A'\n port: 9003"}])
# }

#   depends_on = [
#     var.depends-on-node-pool
#   ]

#   count = var.prometheus-count
# }

# # https://artifacthub.io/packages/helm/bitnami/kube-prometheus
# # Current Verison = --version 8.15.2 . kubecost-cost-analyzer-77556b999c-dfwmb