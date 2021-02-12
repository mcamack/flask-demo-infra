resource "aws_s3_bucket" "flask-demo" {
  bucket = "s3-flask-demo-matt"
  acl    = "public-read"
}