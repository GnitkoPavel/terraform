variable "security_group" {
  description = "Security group ID from network module"
}
variable "subnets" {
  description = "Subnets IDs of default VPC from network module"
}
variable "instance_type" {
  description = "Instance type for EC2 in AutoScaling groups"
  default = "t2.micro"
}

variable "key_name" {
  description = "Name of ssh key for EC2 instances"
  default = "jenkins"
}
variable "public_key_path" {
  description = "Path to private key"
  default = "/root/.ssh/id_rsa.pub"
}

variable "availability_zones" {}