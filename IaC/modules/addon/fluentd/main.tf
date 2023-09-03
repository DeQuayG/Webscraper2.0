# resource "helm_release" "fluentd" {
#   name       = "fluentd"
#   repository = "https://github.com/bitnami/charts/tree/main/bitnami"
#   chart      = "fluentd"
#   namespace  = "default"
#   #version         = "5.8.6"
#   cleanup_on_fail = true

#   depends_on = [
#     var.depends-on-node-pool
#   ]

#   count = var.fluend-count
# }

#https://artifacthub.io/packages/helm/bitnami/fluentd
# Current Version = --version 5.8.6

resource "null_resource" "fluentd_installation" {
  provisioner "local-exec" {
    command = <<-EOF
      helm repo add fluentd/bitnami https://charts.bitnami.com/bitnami
      helm install fluentd oci://registry-1.docker.io/bitnamicharts/fluentd
    EOF
  }

  depends_on = [
    var.depends-on-node-pool
  ]

  count = var.fluend-count
}