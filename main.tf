module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

#module "eks" {
#  source = "terraform-aws-modules/eks/aws"
  #cluster_name = var.cluster_name
  #cluster_version = "1.30"
 # subnet_ids = module.vpc.private_subnets
  #vpc_id = module.vpc.vpc_id
  #enable_irsa = true
  #cluster_endpoint_public_access = true
  #eks_managed_node_groups = {
   # default = {
    #  instance_types = ["t3.medium"]
     # desired_size = 1
     # min_size = 1
      #max_size = 1
      #disk_size = 30
    #}
  #}
#}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  bootstrap_self_managed_addons = true
  cluster_upgrade_policy = {
   support_type = "STANDARD"
  }
  cluster_addons = {
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
#enable_irsa	Determines whether to create an OpenID Connect Provider for EKS to enable IRSA
enable_irsa = true
  vpc_id                   =  module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
