# resource "aws_eks_node_group" "main" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "${var.cluster_name}-main"
#   node_role_arn   = aws_iam_role.node_group.arn
#   subnet_ids      = aws_subnet.private[*].id

#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable_percentage = 33
#   }

#   instance_types = ["t3.medium"]

#   disk_size = 20

#   labels = {
#     role = "general"
#   }

#   tags = {
#     "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
#     "k8s.io/cluster-autoscaler/enabled"             = "true"
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.node_policies
#   ]
# }


## cheap spot node group for cost savings, but with taints to avoid scheduling normal workloads on them
resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-spot"
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = aws_subnet.private[*].id
  capacity_type   = "SPOT"
  ami_type        = "AL2023_ARM_64_STANDARD"

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = [ "t4g.medium"]

  disk_size = 20

  depends_on = [
    aws_iam_role_policy_attachment.node_policies
  ]

  tags = {
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"             = "true"
  }

#   taint {
#     key    = "spot"
#     value  = "true"
#     effect = "NO_SCHEDULE"
#   }
}



## storage 
resource "null_resource" "kubectl_config" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
  }
  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "vpc-cni"
  addon_version = "v1.23.1-eksbuild.1"
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "aws-ebs-csi-driver"
  addon_version = "v1.66.0-eksbuild.1"
}

