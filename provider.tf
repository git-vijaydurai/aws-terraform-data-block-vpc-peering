# Configure the AWS Provider

provider "aws" {

  region                   = "us-east-2"
  shared_credentials_files = ["/home/e1087/live-infra/.aws/credentials"]

}