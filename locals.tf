# account-id
locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  env_identifier    = substr(var.environment, 0, 1)
  alias_kms_key_app = format("kms-%s-%s-euw1-key", var.app_name, local.env_identifier)
}

locals {
  # Defines short environment name
  env_map = {
    "development" = "dev"
    "test"        = "test"
    "acceptance"  = "acc"
    "production"  = "prod"
  }
  env_short = lookup(local.env_map, var.environment, null)
}

locals {
  # Set default of using cluster resources to acceptance and production
  # Allow override to create cluster in development or test
  default_cluster = {
    "development" = false
    "test"        = false
    "acceptance"  = true
    "production"  = true
  }
  default_cluster_resources =  lookup(local.default_cluster, var.environment, false)
  cluster_resources         = local.default_cluster_resources || var.override_cluster_resources
}

locals {
  # Users to application
  ports-ingress-app = [443]
  protocol_map      = {for idx, val in local.ports-ingress-app: idx => val} 
}
