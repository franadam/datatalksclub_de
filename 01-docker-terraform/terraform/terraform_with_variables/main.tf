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
  region      = var.region
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_tag_name
  }
}

# Create a s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name
  force_destroy = true

  tags = {
    Name = var.s3_bucket_tag_name
    Environment = var.s3_bucket_tag_environment 
  }
}

# Create a redshift serverless namespace
resource "aws_redshiftserverless_namespace" "redshift_namespace" {
  namespace_name = var.redshift_name_space_name
}

# Create a redshift serverless workgroup
resource "aws_redshiftserverless_workgroup" "redshift_workgroup" {
  namespace_name = aws_redshiftserverless_namespace.redshift_namespace.namespace_name
  workgroup_name = var.redshift_workgroup_name
}