data "scaleway_account_project" "default_project" {
  name = "landing-zone-${var.environment}"
}

data "github_actions_secrets" "argocd_repo_write_token" {
  name = "ARGOCD_REPO_WRITE_TOKEN"
}