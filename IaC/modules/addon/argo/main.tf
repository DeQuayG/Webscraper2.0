# we will need this file in case we use private repo
#  data "templatefile" "argo_template" {
#    template = file("${path.module}/templates/k8s-manifests-repo.yaml")
#  }

#  resource "null_resource" "argo_cd" {
#    depends_on = [var.depends-on-node-pool]

#    triggers = {
#      template = "${data.templatefile.argo_template.rendered}"
#   }

#    provisioner "local-exec" {
#      command = <<EOT
#        echo  '${data.templatefile.argo_template.rendered}' | kubectl apply -f -
#      EOT
#    }

#   count = var.argocd-count
#  }
