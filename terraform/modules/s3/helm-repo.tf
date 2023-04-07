resource "aws_s3_bucket" "helm_repo" {
  bucket = "${var.project_name}-helm-chart"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    
    expiration {
        days = var.objects_expire_days
    }
  }

  tags = {
    Name        = "${var.project_name}-helm-chart"
  }
}

resource "aws_s3_bucket_object" "web" {
    bucket = aws_s3_bucket.helm_repo.id
    acl    = "private"
    key    = "web/"
    source = "/dev/null"
}

resource "aws_s3_bucket_object" "api" {
    bucket = aws_s3_bucket.helm_repo.id
    acl    = "private"
    key    = "api/"
    source = "/dev/null"
}
