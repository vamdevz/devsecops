resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-demo-bucket"
}

resource "aws_s3_bucket_acl" "public_acl" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "private"  # Changed from "public-read"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.public_bucket.id
  block_public_acls       = true    # Changed from false
  block_public_policy     = true    # Changed from false
  ignore_public_acls      = true    # Changed from false
  restrict_public_buckets = true    # Changed from false
}

# Add encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.public_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Add versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.public_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Add access logging
resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.public_bucket.id

  target_bucket = aws_s3_bucket.public_bucket.id
  target_prefix = "logs/"
}

# Add lifecycle policy
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.public_bucket.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}