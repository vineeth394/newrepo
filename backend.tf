terraform {
  backend "s3" {
    bucket = "terraform-cloud-jenkins394"
    key = "remote.tfstate"
    region = "ap-south-1"
  }
}
