output "k8s_cluster_name" {
  value = "${var.cluster_name}.${var.cluster_domain_name}"
}

output "s3_kops_state_store" {
  value = "s3://clusters.${var.cluster_domain_name}"
}
