variable "region" {
  description = "Region"
  default     = "eu-west-3"
}

variable "vpc_cidr_block" {
  description = "My VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "vpc_tag_name" {
  description = "My VPC Name"
  default     = "my-tf-vpc"
}

variable "s3_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "tf-s3-bucket-dtc-de"
}

variable "s3_bucket_tag_name" {
  description = "My bucket tag Name"
  default     = "my-tf-bucket"
}

variable "s3_bucket_tag_environment" {
  description = "My bucket Environment"
  default     = "Dev"
}

variable "redshift_name_space_name" {
  description = "My Redshift Name space"
  default     = "tf-redshift-namespace"
}

variable "redshift_workgroup_name" {
  description = "My Redshift workgroup"
  default     = "tf-redshift-workgroup"
}
