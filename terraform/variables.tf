variable "aws_region" {}
variable "environment" {}
variable "vpc_cidr" {}
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "ami_id" {}
variable "instance_type" {}
variable "db_instance_class" {}
variable "db_username" {}
variable "db_password" {
  sensitive = true
}