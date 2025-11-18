output "kubeconfig" {
  value = {
    name     = module.eks.cluster_name
    endpoint = module.eks.cluster_endpoint
    ca       = module.eks.cluster_certificate_authority_data
  }
}
output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = try(module.eks.this[0].identity[0].oidc[0].issuer, null)
}