resource "aws_kms_key" "etcd_key" {
  description = "KMS key for secret encryption in ETCD"

    tags = merge(
      var.common_tags,
      {
        Name = "etcd_kms"
      }
  )
}