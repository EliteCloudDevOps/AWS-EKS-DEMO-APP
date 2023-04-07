locals {
  origin_id = var.elb_name
  domain    = var.domain 
}

# CloudFront Identity
# resource "aws_cloudfront_origin_access_identity" "cloudfront_access_identity" {
#   comment  = "${project_name}-identity"
# }

# Cloudfront Distribution
resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  comment = "${var.project_name}-cf"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = ""
  aliases = [
    local.domain,
  ]

  origin {
    domain_name = local.origin_id
    origin_id   = local.origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" #match-viewer
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2", "SSLv3"]
    }
  }


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.elb_name

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 10
    default_ttl            = 300
    max_ttl                = 600
  }

  http_version = "http2"

  price_class = "PriceClass_100" 
  # Only U.S., Canada and Europe

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # viewer_certificate {
  #   cloudfront_default_certificate = false #false
  #   acm_certificate_arn            = "arn:aws:acm:us-east-1:849837580380:certificate/782865c4-f81b-49fa-aec3-cc3b68e4c7a1"
  #   # iam_certificate_id             = ""
  #   minimum_protocol_version       = "TLSv1.2_2019"
  #   ssl_support_method             = "sni-only"
  # }

  tags = {
    description = "The CloudFront distribution to serve ${local.domain} from edge locations"
    environment = "${terraform.workspace}"
  }

}


//s3 bucket policy
# data "aws_iam_policy_document" "cloudfront_s3_policy" {
#   statement {
#     actions   = ["s3:GetObject"]
#     resources = ["arn:aws:s3:::${local.bucket_name}/*"]

#     principals {
#       type        = "AWS"
#       identifiers = [aws_cloudfront_origin_access_identity.cloudfront_access_identity.iam_arn]
#     }
#   }
# }

# resource "aws_s3_bucket_policy" "dev_bucket_policy" {
#   bucket = local.bucket_name
#   policy = data.aws_iam_policy_document.cloudfront_s3_policy.json
# }
