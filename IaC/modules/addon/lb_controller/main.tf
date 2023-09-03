resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  #version    = var.lb_controller_version

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
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = var.load_balancer_controller_sa_name
  }
  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "region"
    value = var.cluster["aws_region"]
  }

  set {
    name  = "cluster_name"
    value = var.cluster_name
  }

  set {
    name  = "enableServiceMutatorWebhook"
    value = true
  }

  set {
    name  = "app.kubernetes.io/managed-by"
    value = "Helm"
  }

  set {
    name  = "meta.helm.sh/release-name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "meta.helm.sh/release-namespace"
    value = "kube-system"
  }

  set {
    name  = "alb.ingress.kubernetes.io/healthcheck-port"
    value = "traffic-port"
  }

  set {
    name  = "alb.ingress.kubernetes.io/target-type"
    value = "ip"
  }

  set {
    name  = "alb.ingress.kubernetes.io/scheme"
    value = "internet-facing"
  }


  depends_on = [
    var.depends-on-node-pool,

  ]
  count = var.lb-controller-count
}


