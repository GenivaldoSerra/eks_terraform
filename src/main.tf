module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_vpc_azs
  private_subnets = var.aws_vpc_private_subnets
  public_subnets  = var.aws_vpc_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.aws_projects_tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.26.1"

  cluster_name    = var.aws_eks_name
  cluster_version = var.aws_eks_version

  enable_cluster_creator_admin_permissions = true

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.default_vpc_id

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      min_size       = 2
      max_size       = 2
      desired_size   = 2
      instance_types = var.aws_eks_managed_node_groups_instance_types
    }
  }
}

variable "aws_region" {
  description = "Região utilizada para criar os recursos da AWS"
  type        = string
  nullable    = false
}

variable "aws_vpc_name" {
  description = "Nome da VPC que será utilizado"
  type        = string
  nullable    = false
}

variable "aws_vpc_cidr" {
  description = "Faixa de IP utilizada na VPC"
  type        = string
  nullable    = false
}

variable "aws_vpc_azs" {
  description = "Zonas de disponibilidades"
  type        = set(string)
  nullable    = false
}

variable "aws_vpc_private_subnets" {
  description = "Lista das subnets privadas"
  type        = set(string)
  nullable    = false
}

variable "aws_vpc_public_subnets" {
  description = "Lista das subnets publicas"
  type        = set(string)
  nullable    = false
}

variable "aws_eks_name" {
  description = "Nome do cluster kurbenets"
  type        = string
  nullable    = false
}

variable "aws_eks_version" {
  description = "Versão do cluster kurbenets"
  type        = string
  nullable    = false
}

variable "aws_eks_managed_node_groups_instance_types" {
  description = "Definição dos nodes do cluster kurbenets"
  type        = set(string)
  nullable    = false
}

variable "aws_projects_tags" {
  description = "Definição de todas as tags utilizadas no projeto"
  type        = map(any)
  nullable    = false
}
