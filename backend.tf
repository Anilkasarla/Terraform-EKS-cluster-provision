</> hcl

terraform {
  backend "s3" {
    bucket = "mlops-dvc-bucket13"
    key = "eks/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"

    encrypt = true

  }

}
