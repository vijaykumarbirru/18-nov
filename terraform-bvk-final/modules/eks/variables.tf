# variable "cluster_name" {
#   type = string
# }

# variable "cluster_version" {
#   type = string
# }

# variable "private_subnet_ids" {
#   type = list(string)
# }

# variable "vpc_id" {
#   type = string
# }

# variable "instance_type" {
#   type = string
# }

# variable "peers_cidrs" {
#   type = list(string)
# }

# variable "tags" {
#   type = map(string)
# }

# variable "cluster_role_arn" {
#   type = string
#   description = "Pre-created EKS cluster role"
# }

# variable "node_role_arn" {
#   type = string
#   description = "Pre-created EKS node IAM role"
# }

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "region" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "addon_versions" {
  type = object({
    vpc_cni                = optional(string, "latest")
    kube_proxy             = optional(string, "latest")
    coredns                = optional(string, "latest")
    eks_pod_identity_agent = optional(string, "latest")
  })
  default = {}
}

