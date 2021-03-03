output "EC2_AMI" {
  value = data.aws_ami.server_ami.id
}
output "AZS" {
  value = data.aws_availability_zones.azs.names
}

output "elb_dns_name" {
  value = aws_elb.example.dns_name
}