
resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name # Must be globally unique

  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_public_access_block" "tf_state_private" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "name" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    # antecipating  block SSE-C uploads for all new bucket from march
    blocked_encryption_types = ["SSE-C"]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "name" {
  bucket = aws_s3_bucket.tf_state.id
  rule {
    id     = "delete_old_non_current"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days           = 10
      newer_noncurrent_versions = 3
    }
    expiration {
      expired_object_delete_marker = true
    }
  }
}
