data "scaleway_account_project" "default_project" {
  name = "landing-zone-${var.environment}"
}

data "github_actions_secret" "argocd_repo_write_token" {
  name = "ARGOCD_REPO_WRITE_TOKEN"
}

#This needs to be created manually in Scaleway console, as it is not possible to create a GitHub actions fine-grained token with the GitHub provider.
data "scaleway_secret_version" "argocd_repository_write_key" {
  secret_name = "argocd_repository_write_key"
  revision    = "latest"
  project_id  = data.scaleway_account_project.default_project.id
}