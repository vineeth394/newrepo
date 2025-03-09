terraform {
  backend "s3" {
    bucket = "tfbucket049884"
    key = "remote.tfstate"
    region = "us-east-2"
  }
}
