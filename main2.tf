
#====================================================================
# Terraform configuration
#====================================================================
terraform {
  required_version = ">=1.6.3"
  required_providers {
    aws = {
      source = "hasicorp/aws"
      version = "~>5.0"
    }
  }
  backend "s3" {
     bucket = "tfstate-bucket-0843738473"
     key    = "dev.tfstate"
     region = "ap-northeast-1"
     profile= "Administrator"     
  }
}

#====================================================================
# Terraform configuration
#====================================================================
provider "aws"  {
  #credentialsに登録しているユーザーを設定する
  profile = "Administrator"
  region  = "ap-northeast-1"
}

provider "aws" {
  alias   = "virginia"
  profile = "Administrator"
  region  = "ap-northeast-1"
}

#====================================================================
# Variables
#====================================================================
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "myip" {
  type = string
}

variable "domain" {
  type = string
}