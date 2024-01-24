resource "aws_s3_bucket" "charonium-image_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.app_name}-${var.env_prefix}-image-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "charonium-bucket-ownership-controls" {
  bucket = aws_s3_bucket.charonium-image_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "charonium-image_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.charonium-bucket-ownership-controls]

  bucket = aws_s3_bucket.charonium-image_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_public_access_block" "charonium-public-access-block" {
  bucket = aws_s3_bucket.charonium-image_bucket.id

  block_public_acls   = false
  ignore_public_acls  = false
  block_public_policy = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "charonium-bucket-policy" {
  bucket = aws_s3_bucket.charonium-image_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Principal = "*"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.charonium-image_bucket.arn}/*"
        # Condition = {
        #   IpAddress = {
        #     "aws:SourceIp" : "161.142.100.0/24"
        #   }
        # }
      }
    ]
  })
}
