## Create S3 bucket
## ref: https://www.terraform.io/docs/providers/aws/r/s3_bucket.html

# useful inspirationA
# proper use of data template to create the final bucket policy
# ref: https://github.com/infrablocks/terraform-aws-encrypted-bucket/blob/master/main.tf
#
# bucket encryption with kms example
# ref: https://github.com/turnerlabs/terraform-s3-employee/blob/master/main.tf

# Simple bucket - dont use it.  Just here to help smoke test
resource "aws_s3_bucket" "simple_bucket" {
  count     = "${length(var.buckets) * var.simple_bucket }"
  bucket    = "${lookup(var.buckets[count.index], "bucket_name")}"
  acl       = "${lookup(var.buckets[count.index], "bucket_acl")}"

  # merge map of tags
  tags  = "${merge(
                map("Name", lookup(var.buckets[count.index], "bucket_name")),
                var.tags)
  }"
}

