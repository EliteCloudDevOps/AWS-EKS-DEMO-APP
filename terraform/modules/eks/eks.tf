resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.cluster_version

  # Ensure that the cluster is only accessible through a VPN.
  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.eks_api.id]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  encryption_config {
    provider {
      key_arn = aws_kms_key.etcd_key.arn
    }

    resources = ["secrets"]
  }

  kubernetes_network_config {
    service_ipv4_cidr = "10.244.240.0/20"
  }

    tags = merge(
      var.common_tags,
      {
        Name    = "${var.project_name}-${terraform.workspace}-cluster"
        Group   = "${var.project_name}"
        Project = "eks"
        Country = "all"
      }
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_cluster_policy,
  ]
}

output "k8s_default_secgroup" {
  value = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.eks.arn
}