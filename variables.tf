#----Networking variables
variable "vpc_cidr" {}
variable "public_cidrs" {
  type = list(string)
}
variable "accessip" {}

#----Compute variables
variable "instance_type" {}
variable "key_name" {}
variable "public_key_path" {}
variable "availability_zones" {}