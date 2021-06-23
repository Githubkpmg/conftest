#This is an AWS provider user to connect to the AWS environment to obtain or perform CRUD operations on resources
provider "aws" {
  profile = "terraform"
  region  = "us-west-1"
}

#This resource is used to create secure S3 bucket
resource "aws_s3_bucket" "secure_s3_bucket" {
  bucket = "terraform-secure-bucket"
  acl    = var.secure_s3_bucket_acl
  
  versioning {
    enabled = var.secure_s3_bucket_versioning
  }

  logging {
    target_bucket = var.server_logging_bucket_name
	target_prefix = var.server_logging_bucket_logging_prefix
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.cmk_key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  

  object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      default_retention {
	    mode = var.secure_s3_bucket_lock_retention_mode
		days = var.secure_s3_bucket_lock_retention_days
	  }
	}	
  }

  tags = {
    OWNER       = var.mandatory_tag_owner
    DESCRIPTION = var.mandatory_tag_description
	CODE        = var.mandatory_tag_code
  }
}


output "secure_s3_bucket_name" {
  value  = aws_s3_bucket.secure_s3_bucket.id
  description  = "This output variable holds the S3 server logging bucket name which can be referrenced in other resources"
}

output "secure_s3_bucket_arn" {
  value  = aws_s3_bucket.secure_s3_bucket.arn
  description  = "This output variable holds the S3 server logging bucket arn which can be referrenced in other resources"
}
