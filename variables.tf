## VARIABLES ##

variable "region" {
  description = "Region we are performing our actions in"
  default     = "us-east-1"
}

variable "buckets" {
  description   = "Array of buckets to create"
  default       = [
      {
          bucket_name   = "simple-test.fatbelly"
          bucket_acl    = "private"
          versioning    = true
      },
      {
          bucket_name   = "simple-test-two.fatbelly"
          bucket_acl    = "private"
          versioning    = false
      }
  ]
  type          = "list"
}

variable "simple_bucket" {
  description   = "Simple bucket, no frills.  Don't use this."
  default       = false
}

variable "log_bucket_name" {
  description   = "Name of the bucket to send activity logs to"
  default       = ""
}

variable "log_bucket_id" {
  description   = "Id of pre-existing bucket to send activity logs to"
  default       = ""
}

variable "enable_encryption" {
  description   = "Enable encryption for the bucket"
  default       = true
}

variable "enable_replication" {
  description   = "Enable bucket replication"
  default       = false
}

variable "replication_region" {
  description   = "Destination region for the bucket replication"
  # too lazy to write logic to automagically pick a good world-wide region based on var.region
  # if you enable replication, then accept this default or explicitly tell the module what region to replicate into
  default       = "us-west-2"
}

variable "key_arn" {
  description   = "ARN of the KMS Key to use for encryption at rest"
  default       = ""
}

variable "key_description" {
  description   = "Useful description for the KMS Key we will created for encrypting the bucket"
  default       = ""
}

variable "deletion_window_in_days" {
  description   = "Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Defaults to 10 days."
  default       = "7"
}

variable "enable_key_rotation" {
  description   = "pecifies whether key rotation is enabled. Defaults to true"
  default       = true
}

variable "tags" {
  description   = "Map of tags to add to the bucket(s)"
  default       = {
      terraform = "true"
  }
}
