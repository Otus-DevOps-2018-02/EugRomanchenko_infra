variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for provisioning"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable reddit_db_addr {
  description = "Internal Mongo DB ip address"
}

variable deploy {
  description = "Flag for deploy"
  default     = "0"
}
