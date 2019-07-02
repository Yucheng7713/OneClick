resource "aws_s3_bucket" "cluster_bucket" {
  count = 1
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

