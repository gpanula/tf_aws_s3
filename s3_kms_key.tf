# kms key for encryption at rest
# ref: https://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html
# ref: https://docs.aws.amazon.com/kms/latest/developerguide/limits.html
# ref: https://aws.amazon.com/kms/pricing/   (hint: $1/month per key)
# ref: https://www.terraform.io/docs/providers/aws/r/kms_key.html

# ref: https://aws.amazon.com/blogs/security/how-to-prevent-uploads-of-unencrypted-objects-to-amazon-s3/

# Decided against a unique per bucket.  If the list of buckets change, this would force a change to the keys
# you could end up with key being deleted from an existing bucket.  Big headaches.
# Keep it simple and go with a single key(for the upstream caller)
resource "aws_kms_key" "bucket_key" {
  count         = "${length(var.key_arn) > 0 ? 0 : 1}"
  description   = "${local.kms_description}"

  # merge map of tags
  tags  = "${merge(
                map("Name", (local.kms_alias)),
                var.tags)
  }"

  deletion_window_in_days   = "${var.deletion_window_in_days}"
  enable_key_rotation       = "${var.enable_key_rotation}"
}

# user-friendly name for the key aka key alias
# ref: https://www.terraform.io/docs/providers/aws/r/kms_alias.html
resource "aws_kms_alias" "s3_key_alias" {
  count         = "${var.enable_encryption}"
  name          = "${format("alias/s3_bucket_%s", replace(local.kms_description, ".", "_"))}"
  target_key_id = "${element(aws_kms_key.bucket_key.*.key_id, count.index)}"
}

