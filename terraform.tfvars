vpc_cidr = "10.60.0.0/16"
public_cidrs = [
  "10.60.1.0/24",
  "10.60.2.0/24",
  "10.60.3.0/24"
]
accessip        = "0.0.0.0/0"
instance_type   = "t2.micro"
key_name        = "jenkins"
public_key_path = "/root/.ssh/id_rsa.pub"
availability_zones = [
  "eu-west-1a",
  "eu-west-1b",
  "eu-west-1c"
]