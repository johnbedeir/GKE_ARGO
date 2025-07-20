resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  namespace  = "kube-system" // It's common to deploy Cluster Autoscaler in the kube-system namespace
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.36.0"

  set {
    name  = "cloudProvider"
    value = "gce"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  // GKE-specific settings
  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.name_prefix}-${var.environment}"
  }

  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

  set {
    name  = "extraArgs.balance-similar-node-groups"
    value = "true"
  }

  set {
    name  = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }

  set {
    name  = "extraArgs.scale-down-enabled"
    value = "true"
  }

  set {
    name  = "extraArgs.scale-down-unneeded-time"
    value = "5m"
  }
}
