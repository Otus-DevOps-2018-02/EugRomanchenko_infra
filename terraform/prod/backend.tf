terraform {
  backend "gcs" {
    bucket = "test1-bucket-eromanchenko"
    prefix = "prod"
  }
}
