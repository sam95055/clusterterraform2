variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the EKS cluster"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Test"
    Owner       = "Team"
    CostCenter  = "ABC123"
  }
}

variable "name_prefix" {
  type    = string
  default = "Test-ABC"
}
output "cluster_name" {
  value = module.eks.cluster_name
}

output "karpenter_role_arn" {
  value = module.karpenter_irsa.iam_role_arn
}


module "karpenter_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role                   = true
  role_name                     = "${var.name_prefix}-karpenter"
  provider_url                  = module.eks.cluster_oidc_issuer_url
  role_policy_arns              = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
  tags                          = var.tags
}

