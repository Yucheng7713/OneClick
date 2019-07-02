resource "null_resource" "cluster_apply" {
  count = 1
  depends_on = ["aws_s3_bucket.cluster_bucket"]

  provisioner "local-exec" {
    command = <<EOF
    kops create cluster --cloud=$CLOUD --zones=${var.aws_az} --name=$NAME --dns-zone=${var.cluster_domain_name} &&
    kops update cluster $NAME --yes
    kops validate cluster
    sleep 500
    kubectl create -f ../k8s/manifests/
    until kubectl get customresourcedefinitions servicemonitors.monitoring.coreos.com ; do date; sleep 1; echo ""; done
    until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
    kubectl apply -f ../k8s/manifests/
    kubectl --namespace monitoring get services
    EOF

    environment = {
      NAME                  = "${var.cluster_name}.${var.cluster_domain_name}"
      CLOUD                 = "${var.cloud_genre}"
    }
  }
}

# until kubectl version; do sleep 20 ; done

resource "null_resource" "app_deploy" {
  count = 1
  depends_on = ["null_resource.cluster_apply"]

  provisioner "local-exec" {
    command = <<EOF
    kubectl create -f ../k8s/flask-app-deployment.yaml
    kubectl create -f ../k8s/flask-app-service.yaml
    kubectl get service/flask-app
    EOF
  }
}

resource "null_resource" "cluster_destroy" {
  count = 1
  depends_on = ["aws_s3_bucket.cluster_bucket"]

  provisioner "local-exec" {
    # The destroy provisioner is run before the bucket is destroyed
    # The cluster will be deleted first
    when  = "destroy"

    command = <<EOF
    kops delete cluster $NAME --yes
    sleep 10
    EOF

    environment = {
      NAME                  = "${var.cluster_name}.${var.cluster_domain_name}"
    }
  }
}