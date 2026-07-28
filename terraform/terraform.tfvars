aws_region          = "ap-south-1"

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"

ami_id              = "ami-xxxxxxxxxxxxxxxxx"   # Replace with the latest Amazon Linux 2023 AMI in ap-south-1
instance_type       = "t2.micro"

db_instance_class   = "db.t3.micro"
db_username         = "postgres"
db_password         = "YourStrongPassword"