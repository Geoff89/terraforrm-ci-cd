resource "aws_s3_bucket" "s3Bucket" {
  bucket = "website-hosting-us-east-1"
}

resource "aws_s3_bucket_policy" "s3BucketPolicy" {
  bucket = aws_s3_bucket.s3Bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MakePublic"
    Statement = [
      {
        Sid       = "PublicAllow"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:DeleteObject", "s3:PutObject"]
        Resource  = "${aws_s3_bucket.s3Bucket.arn}/*"
      },
    ]
  })

}


resource "aws_s3_bucket_ownership_controls" "bucketownership" {
  bucket = aws_s3_bucket.s3Bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "publicab" {
  bucket = aws_s3_bucket.s3Bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucketownership,
    aws_s3_bucket_public_access_block.publicab,
  ]

  bucket = aws_s3_bucket.s3Bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.s3Bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_versioning" "bucketVersioning" {
  bucket = aws_s3_bucket.s3Bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}