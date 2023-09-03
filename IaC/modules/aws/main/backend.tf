terraform {
  backend "s3" {
    bucket = "example-tfstate-this-us-east-1"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}



