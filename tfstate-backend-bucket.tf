# resource "random_integer" "random_id" {
#   min = 1000
#   max = 9999
# }

# resource "aws_s3_bucket" "tf-state-bucket" {
#   bucket = "${var.dev}-tfstate-backend-bucket-${random_integer.random_id.result}"

#   # lifecycle {
#   #   prevent_destroy = true # Prevents accidental deletion
#   # }
# }

# #create a folder with in the current bucket
# resource "aws_s3_object" "folder" {
#   bucket = local.bucket_id #aws_s3_bucket.tf-state-bucket.id
#   key    = "dev"
# }

# #enabling versioning for this bucket
# resource "aws_s3_bucket_versioning" "version" {
#   bucket = local.bucket_id #aws_s3_bucket.tf-state-bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# locals {
#   bucket_id = aws_s3_bucket.tf-state-bucket.id
# }

