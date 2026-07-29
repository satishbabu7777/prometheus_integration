aws_region          = "ap-south-1"
environment         = "dev"

vpc_cidr            = "10.0.0.0/16"

public_subnet1_cidr = "10.0.1.0/24"
public_subnet2_cidr = "10.0.2.0/24"

ami_id              = "ami-0884624fc54d115f3"

instance_type       = "t3.micro"   # or another free-tier-eligible type for your account

db_instance_class   = "db.t3.micro"

db_username         = "postgres"
db_password         = "Satish89babu#"