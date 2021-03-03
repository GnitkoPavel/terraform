#----Networking outputs----
output "public_subnets" {
  value = join(", ", module.network.public_subnets)
}

output "subnet_IPs" {
  value = join(", ", module.network.subnet_ips)
}

output "public_security_groups" {
  value = join(", ", [module.network.public_sg])
}

#----Compute outputs
output "EC2_AMI" {
  value = module.compute.EC2_AMI
}
output "AZS" {
  value = module.compute.AZS
}

output "elb_dns_name" {
  value = module.compute.elb_dns_name
}

output "availability_zones" {
  value = module.network.availability_zones
}