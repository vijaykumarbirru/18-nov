###########################################
# SECURITY GROUP FOR EKS CONTROL PLANE
###########################################

resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-cluster-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow 443 from specified CIDRs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.peers_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

###########################################
# EKS CLUSTER
###########################################

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn   # << USING EXISTING ROLE

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_public_access  = false
    endpoint_private_access = true
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  tags = var.tags
}

###########################################
# IRSA - OPENID CONNECT PROVIDER
###########################################

# Get TLS certificate from the EKS OIDC issuer
data "tls_certificate" "oidc" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# Create OIDC Provider for IRSA
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-oidc-provider"
    }
  )
}

###########################################
# NODE GROUP
###########################################

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = var.node_role_arn   # << USING EXISTING ROLE
  node_group_name = "${var.cluster_name}-ng"
  subnet_ids      = var.private_subnet_ids

  instance_types = [var.instance_type]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 4
  }

  tags = var.tags

  depends_on = [aws_eks_cluster.this]
}

###########################################
# ADDONS
###########################################

resource "aws_eks_addon" "vpc_cni" {
  addon_name                  = "vpc-cni"
  cluster_name                = aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}


resource "aws_eks_addon" "kube_proxy" {
  addon_name                  = "kube-proxy"
  cluster_name                = aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}


resource "aws_eks_addon" "coredns" {
  addon_name                  = "coredns"
  cluster_name                = aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}


resource "aws_eks_addon" "ebs_csi" {
  addon_name                  = "aws-ebs-csi-driver"
  cluster_name                = aws_eks_cluster.this.name
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}


