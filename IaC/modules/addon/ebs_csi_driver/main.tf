resource "helm_release" "ebs_csi_driver" {
  name       = "ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  #version    = "v1.21.0"
  namespace       = "kube-system"
  cleanup_on_fail = true

  set {
    name  = "enableVolumeResizing"
    value = "true"
  }
  set {
    name  = "enableVolumeSnapshot"
    value = "true"
  }

  set {
    name  = "enableVolumeScheduling"
    value = "true"
  }

  set {
    name  = "enableVolumeSnapshotPVC"
    value = "true"
  }

  set {
    name  = "ControllerPublishCSIVolumnes"
    value = "true"
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
    value = true
  }
  set {
    name  = "manager.securityContext.seccompProfile.type"
    value = "Localhost"
  }

  set {
    name  = "serviceAccountName"
    value = var.ebs_csi_driver_service_account_name
  }


  depends_on = [
    var.depends-on-node-pool
  ]

  count = var.ebs-csi-count
}