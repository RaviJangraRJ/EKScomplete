terraform {
  backend "s3" {
    bucket = "terraform-eks-ravi"
    key    = "eks/terraform.tfstate"
    dynamodb_table  = "terraform-lock"
    region = "ap-south-1"
  }
}
