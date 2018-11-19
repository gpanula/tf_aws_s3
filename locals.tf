### Locals ###

# get the aws account of the caller
# ${data.aws_caller_identity.current.account_id}  will give you the account_id
data "aws_caller_identity" "current" {}

# random number
resource "random_id" "random_bucket_uid" {
  # we were passed either a log bucket id or log bucket name, we don't need to create a random uid
  count   = "${length(var.buckets) * (length(var.log_bucket_id) + length(var.log_bucket_name) > 0 ? 0 : 1) }"
  keepers = {
    # Generate a new random number when the first S3 bucket name changes
    # if empty bucket list, then we're just creating a log bucket. create a single uid
    log_bucket_name = "${length(var.buckets) > 0 ? lookup(var.buckets[0], "bucket_name") : 1 }"
  }

  byte_length = 2
}

# unique id used in the kms key alias name
resource "random_id" "random_key_uid" {
  keepers = {
    # first S3 bucket name changes
    # if empty bucket list, then we're just creating a log bucket. create a single uid
    kms_key_arn = "${local.encryption_key}"
  }

  byte_length = 8
}

locals {
    account_id              = "${data.aws_caller_identity.current.account_id}"
    bucket_uid              = "${random_id.random_bucket_uid.dec}"
    #key_uid                 = "${random_id.random_key_uid.dec}"

  # determine name of bucket to send logs to
    log_destination_id      = "${length(var.log_bucket_id) > 0 ?
                                    var.log_bucket_id
                                    :
                                    aws_s3_bucket.log_bucket.id
                                }"

    log_destination_name    = "${length(var.log_bucket_name) >  0 ?
                                    var.log_bucket_name
                                    :
                                    format("%s-logs.uid.%s", 
                                        local.account_id, 
                                        local.bucket_uid)
                                }"

    encryption_key          = "${length(var.key_arn) > 0 ?
                                    var.key_arn
                                    :
                                    aws_kms_key.bucket_key.0.arn
                                }"

    kms_description         = "${length(var.key_description) > 0 ?
                                    var.key_description
                                    :
                                    format("%s-s3-uid.%s",
                                        local.account_id,
                                        local.bucket_uid)
                                }"

    kms_alias               = "${format("s3_encryption_key_uid_", local.bucket_uid)}"


}

# determine name of bucket to send logs to
