resource "aws_eks_node_group" "eks_testapp_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "testapp-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnets
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    role       = "worker-nodes"
    node-group = "testapp-nodes"
  }

    tags = merge(
      var.common_tags,
      {
          Name                                         = "${var.project_name}-${terraform.workspace}-testapp-nodes"
          "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
          "k8s.io/cluster-autoscaler/enabled"          = true
      }
  )

    # taint  {
    #   key = "testapp"
    #   value = "true"
    #   effect = "NO_SCHEDULE"
    # }  
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_nodes_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}