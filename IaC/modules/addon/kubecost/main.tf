resource "helm_release" "kubecost" {
  name             = "kubecost"
  repository       = "https://kubecost.github.io/cost-analyzer"
  chart            = "cost-analyzer"
  version          = var.kubecost_version
  namespace        = var.kubecost_namespace
  create_namespace = false
  cleanup_on_fail  = true
  atomic           = true

  set {
    name  = "serviceAccount.name"
    value = var.kubecost_sa_name
  }

  set {
    name  = "kubecostMetrics.emitPodAnnotations"
    value = true
  }

  set {
    name  = "kubecostMetrics.emitNamespaceAnnotations"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "remoteReadEnabled"
    value = true
  }

  set {
    name  = "podSecurityPolicy.enabled"
    value = false
  }

  set {
    name  = "networkCosts.podSecurityPolicy.enabled"
    value = false
  }

  set {
    name  = "prometheus.podSecurityPolicy.enabled"
    value = false
  }

  set {
    name  = "grafana.rbac.pspEnabled"
    value = false
  }
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
    value = false
  }
  set {
    name  = "manager.securityContext.seccompProfile.type"
    value = "Localhost"
  }

  set {
    name  = "global.grafana.domainName"
    value = "kubecost-grafana.kubecost"
  }

  set {
    name  = "global.prometheus.enabled"
    value = true
  }

  set {
    name  = "prometheus.nodeExporter.enabled"
    value = "false"
  }

  set {
    name  = "prometheus.kube-state-metrics.disabled"
    value = true
  }

  set {
    name  = "prometheus.serviceAccounts.nodeExporter.create"
    value = false
  }

  set {
    name  = "persistentVolume.dbPVEnabled"
    value = true
  }

  set {
    name  = "persistentVolume.storageClass"
    value = "gp2"
  }

  set {
    name  = "ingress.kubecost-cost-analyzer.ingressClassName"
    value = "alb"
  }

  set {
    name  = "ingress.kubecost-cost-analyzer.enabled"
    value = true
  }

  set {
    name  = "ingress.className"
    value = "alb"
  }

  set {
    name  = "ingress.kubecost-cost-analyzer.hosts[0]"
    value = var.load_balancer_dns_name
  }

  set {
    name  = "prometheus.server.persistentVolume.enabled"
    value = true
  }

  set {
    name  = "grafana.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "grafana.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "grafana.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "grafana.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "networkCosts.enabled"
    value = true
  }

  set {
    name  = "sidecar.dashboards.enabled"
    value = true
  }

  set {
    name  = "kubecostFrontend.image"
    value = "gcr.io/kubecost1/frontend"
  }

  set {
    name  = "kubecostModel.image"
    value = "gcr.io/kubecost1/cost-model"
  }

  set {
    name  = "kubecostModel.cloudCost.enabled"
    value = true
  }

  set {
    name  = "kubecostModel.cloudCost.labelList.isIncludeList"
    value = false
  }

  set {
    name  = "kubecostModel.cloudCost.labelList.labels"
    value = ""
  }

  set {
    name  = "sidecar.dashboards.searchNamespace"
    value = "ALL"
  }

  set {
    name  = "cloudCost.enabled"
    value = true
  }

  set {
    name  = "labelList.isIncludeList"
    value = false
  }

  set {
    name  = "kubecostModel.cloudCost.topNItems"
    value = 1000
  }

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "networkPolicy.enabled"
    value = false
  }

  set {
    name  = "grafana.sidecar.datasources.defaultDatasourceEnabled"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = var.kubecost_sa_name
  }

  set {
    name  = "service.type"
    value = "NodePort"
  }

  depends_on = [
    var.depends-on-ebs-csi-driver,
    var.vpc_id,
    var.cluster,
  ]
  count = var.kubecost-count
}

resource "null_resource" "update_service_account" {
  triggers = {
    depends_on = var.depends-on-node-pool
  }

  provisioner "local-exec" {
    command = "bash update_sa.sh"
  }
}



resource "null_resource" "apply_ingress" {
  triggers = {
    template_body = file("${path.module}/kubecost-ingress.yaml")
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo '${file("${path.module}/kubecost-ingress.yaml")}' | kubectl apply -f -
    EOT

    environment = {
      config_path = "~/.kube/config"
    }
  }
}


