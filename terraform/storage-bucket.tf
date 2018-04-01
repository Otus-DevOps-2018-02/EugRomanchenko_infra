provider "google" {
 version = "1.4.0"
 project = "${var.project}"
 region = "${var.region}"
}
module "storage-bucket" {
 source = "SweetOps/storage-bucket/google"
 version = "0.1.1"
 name = ["test1-bucket-eromanchenko", "test2-bucket-eromanchenko"]
}
output storage-bucket_url {
 value = "${module.storage-bucket.url}"
}
