# This is terraform module that creates and manage S3 bucket and a dynamo db to store state
# Files remotely and enable remote state locking. 

resource "random_string" "random" {
  length           = 4
  special          = true
  override_special = "/@£$"
}

resource "aws_s3_bucket" "cloudgen-s3" {
  bucket = "cloudgen-bucket-${random_string.random.id}"

  versioning {
    enabled = true
  }

   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
      }
    }
  }
}