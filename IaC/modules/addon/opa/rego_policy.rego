resource "kubernetes_config_map" "rego_policy" {
  metadata {
    name      = "rego-policy"
    namespace = "default"
  }

  data = {
    policy.rego = <<EOF
package main

violation[{"msg": msg}] {
  container := input.containers[_]
  not container.securityContext.allowPrivilegeEscalation
  container.securityContext.capabilities.drop[_] != "ALL"
  not container.securityContext.runAsNonRoot
  not container.securityContext.seccompProfile.type == "RuntimeDefault"
  msg := sprintf("Container %s does not conform to PodSecurityPolicy", [container.name])
}
EOF
  }
}