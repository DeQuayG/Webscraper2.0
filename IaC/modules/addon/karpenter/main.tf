resource "helm_release" "karpenter" {
  name             = "karpenter"
  repository       = "https://charts.karpenter.sh"
  chart            = "karpenter"
  namespace        = "karpenter"
  version          = var.karpenter_version
  create_namespace = false
  cleanup_on_fail  = true

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

  set {
    name  = "cluster.aws.enabled"
    value = true
  }
  set {
    name  = "cluster.aws.region"
    value = var.cluster["aws_region"]
  }
  set {
    name  = "cluster.aws.vpc"
    value = var.vpc_id
  }
  set {
    name  = "cluster.aws.subnet"
    value = join(" ", slice(local.subnet_ids, 0, length(local.subnet_ids) - 1))
  }
  set {
    name  = "metrics.enabled"
    value = "true"
  }
  set {
    name  = "metrics.provider"
    value = "prometheus"
  }
  set {
    name  = "scaling.enabled"
    value = "true"
  }
  set {
    name  = "scaling.ttlSecondsAfterEmpty"
    value = var.karpenter_ttl
  }

  set {
    name  = "serviceAccountName"
    value = var.karpenter_sa_name
  }

  set {
    name  = "logLevel"
    value = "debug"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "limits.resources.cpu"
    value = "2000"
  }

  set {
    name  = "limits.resources.memory"
    value = "1500Gi"
  }

  set {
    name  = "hostNetwork"
    value = false
  }

  set {
    name  = "controller.healthProbe.port"
    value = "80"
  }

  set {
    name  = "webhook.port"
    value = "8443"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.karpenter_role_arn
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = var.instance_profile_name
  }

  set {
    name  = "kubeletConfiguration.containerRuntime"
    value = "dockerd"
  }

  depends_on = [
    var.depends-on-node-pool,

  ]
  count = var.karpenter-count
}

locals {
  subnet_ids = [
    var.public_subnet1,
    var.public_subnet2,
    var.public_subnet3,

    var.private_subnet1,
    var.private_subnet2,
    var.private_subnet3,
  ]
}


resource "null_resource" "apply_deployment" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/deployment.yaml"
    environment = {
      config_path = "~/.kube/config"
    }
  }
}

resource "null_resource" "apply_provisioner" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/provsioner.yaml"
    environment = {
      config_path = "~/.kube/config"
    }
  }
}




