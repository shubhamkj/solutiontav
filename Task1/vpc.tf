module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "my-vpc"
  cidr = "172.16.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["172.16.186.0/24", "172.16.187.0/24", "172.16.188.0/24"]
  public_subnets  = ["172.16.189.0/24", "172.16.190.0/24", "172.16.191.0/24"]

  private_subnet_tags = { Purpose = "Jenkins" }
  public_subnet_tags = { Purpose = "Minikube" }

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}