## This will create the destination bucket for receiving the activity logs for the buckets we create

# create single bucket to collect the activity logs
resource "aws_s3_bucket" "log_bucket" {
  count     = "${length(var.log_bucket_id) > 0 ? 0 : 1}"
  bucket    = "${local.log_destination_name}"
  acl       = "private"

  # merge map of tags
  tags  = "${merge(
                map("Name", local.log_destination_name),
                var.tags)
  }"

  # enable encryption at rest
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.bucket_key.0.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

