variable "cluster_name" {
  description = "EKS playground cluster name"
  type        = string
  default     = "playground_1"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.36"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  type    = string
  default = "development"
}