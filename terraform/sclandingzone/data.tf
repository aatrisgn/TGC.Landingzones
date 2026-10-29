data "scaleway_account_project" "default_project" {
  name = "landing-zone-${var.environment}"
}

#This needs to be created manually in Scaleway console, as it is not possible to create a GitHub actions fine-grained token with the GitHub provider.
data "scaleway_secret_version" "argocd_repository_write_key" {
  secret_name = "argocd_repository_write_key"
  revision    = "latest"
  project_id  = data.scaleway_account_project.default_project.id
}

data "scaleway_secret_version" "github_app_installation_id" {
  secret_name = "GITHUB_CLAUDE_APP_ID"
  revision    = "latest"
  project_id  = data.scaleway_account_project.default_project.id
}

data "scaleway_secret_version" "github_app_private_key" {
  secret_name = "GITHUB_CLAUDE_PRIVATE_KEY"
  revision    = "latest"
  project_id  = data.scaleway_account_project.default_project.id
}

data "scaleway_secret_version" "claude_code_oauth_token" {
  secret_name = "CLAUDE_CODE_OAUTH_TOKEN"
  revision    = "latest"
  project_id  = data.scaleway_account_project.default_project.id
}
