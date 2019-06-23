# Specify regions where resources will be available
variable "cloud_genre" {
  description = "Choice of cloud infrastructure"
  default = "aws"
}

variable "aws_region" {
  description = "Specify provider's region"
  default     = "us-west-2"
}

variable "aws_az" {
  description = "Availability zones for creating Kubernetes cluster"
  default = "us-west-2a"
}

variable "cluster_domain_name" {
  description = "domain domain name used by cluster"
}

variable "cluster_name" {
  description = "cluster name used under the domain"
  default     = "mycluster"
}

# Name variable used to name resources
variable "fellow_name" {
  description = "The name that will be tagged on your resources."
}

# AWS IAM credentials - USE WITH CAUSTION!!!
variable "aws_iam_access_key" {}

variable "aws_iam_secret_key" {}
