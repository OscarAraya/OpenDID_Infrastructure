# # # CloudFront S3 Implementation
# # resource "aws_s3_bucket" "main" {
# #   bucket = var.bucket_name
# # }

# # resource "aws_s3_bucket_ownership_controls" "main" {
# #   bucket = aws_s3_bucket.main.id
# #   rule {
# #     object_ownership = "BucketOwnerPreferred"
# #   }
# # }

# # resource "aws_s3_bucket_public_access_block" "main" {
# #   bucket                  = aws_s3_bucket.main.id
# #   block_public_acls       = true
# #   block_public_policy     = true
# #   ignore_public_acls      = true
# #   restrict_public_buckets = true
# # }

# # resource "aws_cloudfront_origin_access_control" "oac" {
# #   name                  = "${aws_s3_bucket.main.bucket}-oac"
# #   description           = "OAC for ${aws_s3_bucket.main.bucket}"
# #   origin_access_control_origin_type = "s3"
# #   signing_behavior      = "always"
# #   signing_protocol      = "sigv4"
# # }

# # resource "aws_s3_bucket_policy" "web_bucket_policy" {
# #   bucket = aws_s3_bucket.main.id
# #   depends_on = [aws_s3_bucket_public_access_block.main]
# #   policy = jsonencode({
# #     Version = "2012-10-17"
# #     Statement = [
# #       {
# #         Sid    = "AllowCloudFrontAccess"
# #         Effect = "Allow"
# #         Principal = {
# #           Service = "cloudfront.amazonaws.com"
# #         }
# #         Action   = "s3:GetObject"
# #         Resource = "${aws_s3_bucket.main.arn}/*"
# #       }
# #     ]
# #   })
# # }

# # resource "aws_cloudfront_distribution" "cdn" {
# #   enabled             = true
# #   is_ipv6_enabled     = true
# #   default_root_object = "index.html"
# #   price_class = "PriceClass_100"

# #   origin {
# #     domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
# #     origin_id                = "s3-${aws_s3_bucket.main.bucket}"
# #     origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
# #   }

# #   default_cache_behavior {
# #     target_origin_id       = "s3-${aws_s3_bucket.main.id}"
# #     viewer_protocol_policy = "redirect-to-https"

# #     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
# #     cached_methods   = ["GET", "HEAD"]
# #   }

# #   restrictions {
# #     geo_restriction {
# #       restriction_type = "none"
# #     }
# #   }

# #   # Uses the default CloudFront certificate on *.cloudfront.net
# #   viewer_certificate {
# #     cloudfront_default_certificate = true
# #     minimum_protocol_version       = "TLSv1.2_2021"
# #   }

# #   depends_on = [
# #     aws_s3_bucket_policy.web_bucket_policy
# #   ]
# # }

# # CloudFront Distribution for ALB HTTP
# resource "aws_cloudfront_distribution" "cdn" {
#   origin {
#     domain_name = var.aws_lb_web_dns_name
#     origin_id   = "ALB-${var.aws_lb_web_name}"
    
#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "http-only" # Change to https-only for custom domain
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "CloudFront distribution for ${var.name} ALB"

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = "ALB-${var.aws_lb_web_name}"

#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"  # Redirect HTTP to HTTPS

#     forwarded_values {
#       query_string = true
#       headers      = ["*"]  # Forward all headers to ALB

#       cookies {
#         forward = "all"
#       }
#     }

#     min_ttl     = 0
#     default_ttl = 3600
#     max_ttl     = 86400
#   }

#   price_class = "PriceClass_100"  # US/Canada/Europe

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true  # Use CloudFront's default SSL cert
#     # For custom domains:
#     # acm_certificate_arn      = var.acm_certificate_arn
#     # ssl_support_method       = "sni-only"
#     # minimum_protocol_version = "TLSv1.2_2021"
#   }

#   tags = {
#     Name        = "${var.name}-cloudfront-alb"
#   }
# }