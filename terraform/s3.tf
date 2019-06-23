resource "aws_s3_bucket" "cluster_bucket" {
  bucket = "clusters.${var.cluster_domain_name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = true

  tags = {
    terraform   = "true"
    Environment = "dev"
  }
}

resource "null_resource" "cluster_apply" {

  depends_on = ["aws_s3_bucket.cluster_bucket"]

  provisioner "local-exec" {
    command = <<EOF
    kops create cluster --cloud=$CLOUD --zones=${var.aws_az} --name=$NAME --dns-zone=${var.cluster_domain_name} &&
    kops update cluster $NAME --yes
    sleep 500
    kubectl create -f ../k8s/flask-app-deployment.yaml
    kubectl create -f ../k8s/flask-app-service.yaml
    kubectl create -f ../k8s/manifests/
    until kubectl get customresourcedefinitions servicemonitors.monitoring.coreos.com ; do date; sleep 1; echo ""; done
    until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
    kubectl apply -f ../k8s/manifests/
    EOF

    environment = {
      AWS_ACCESS_KEY_ID     = "${var.aws_iam_access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.aws_iam_secret_key}"
      KOPS_STATE_STORE      = "s3://clusters.${var.cluster_domain_name}"
      NAME                  = "${var.cluster_name}.${var.cluster_domain_name}"
      CLOUD                 = "${var.cloud_genre}"
    }
  }
}

resource "null_resource" "cluster_destroy" {

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
      AWS_ACCESS_KEY_ID     = "${var.aws_iam_access_key}"
      AWS_SECRET_ACCESS_KEY = "${var.aws_iam_secret_key}"
      KOPS_STATE_STORE      = "s3://clusters.${var.cluster_domain_name}"
      NAME                  = "${var.cluster_name}.${var.cluster_domain_name}"
    }
  }
}

