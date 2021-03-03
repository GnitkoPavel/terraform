variable "vpc_cidr" {
  default = "10.60.0.0/16"
  description = "Default VPC"
}

variable "public_cidrs" {
  type = list(any)
  default = [
    "10.60.1.0/24",
    "10.60.2.0/24",
    "10.60.3.0/24"
  ]
  description = "CIDRs range for public subnets"
}

variable "accessip" {
  default = "0.0.0.0/0"
  description = "Allowed range of IP for inbound connection"
}

variable "availability_zones" {
  default = [
    "eu-west-1a",
    "eu-west-1b",
    "eu-west-1c"
  ]
}