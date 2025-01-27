terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# add region
provider "aws" {
  region  = "eu-west-3"
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-tf-vpc"
  }
}

# Create a s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "tf-s3-bucket-dtc-de"
  force_destroy = true

  tags = {
    Name        = "my-tf-bucket"
    Environment = "Dev"
  }
}

# Create a redshift serverless namespace
resource "aws_redshiftserverless_namespace" "redshift_namespace" {
  namespace_name = "tf-redshift-namespace"
}

# Create a redshift serverless workgroup
resource "aws_redshiftserverless_workgroup" "redshift_workgroup" {
  namespace_name = aws_redshiftserverless_namespace.redshift_namespace.namespace_name
  workgroup_name = "tf-redshift-workgroup"
}