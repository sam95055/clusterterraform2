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
