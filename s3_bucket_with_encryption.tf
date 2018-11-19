### S3 Bucket with encryption

resource "aws_s3_bucket" "bucket_with_encryption" {
  # if replication is *not* enabled, then we create our encrypted S3 bucket(s)
  count     = "${var.enable_replication == 0 ? length(var.buckets) : 0}"
  bucket    = "${lookup(var.buckets[count.index], "bucket_name")}"
  acl       = "${lookup(var.buckets[count.index], "bucket_acl")}"

  # merge map of tags
  tags  = "${merge(
                map("Name", lookup(var.buckets[count.index], "bucket_name")),
                var.tags)
  }"
  
  versioning {
    enabled = "${lookup(var.buckets[count.index], "versioning")}"
  }

  # enable encryption at rest
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${local.encryption_key}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # where to send activity logs
  logging {
    target_bucket = "${local.log_destination_id}"
    #target_prefix = "${format("log/%s", lookup(var.buckets[count.index], "bucket_name"))}"
    #target_prefix = "${lookup(var.buckets[count.index], "bucket_name")}"
    target_prefix = "${format("%s_logs/", lookup(var.buckets[count.index], "bucket_name"))}"
  }

}
