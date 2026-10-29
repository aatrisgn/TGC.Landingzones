resource "github_app_installation_repository" "some_app_repo" {
  installation_id = var.github_app_installation_id
  repository      = var.repository_name
}

resource "github_actions_secret" "claude_code_oauth_token_secret" {
  repository  = var.repository_name
  secret_name = "claude_code_oauth_token"
  value       = sensitive(base64decode(var.claude_code_oauth_token))
}

resource "github_actions_secret" "github_app_private_key_secret" {
  repository  = var.repository_name
  secret_name = "github_app_private_key"
  value       = sensitive(base64decode(var.github_app_private_key))
}

resource "github_actions_secret" "github_app_installation_id_secret" {
  repository  = var.repository_name
  secret_name = "github_app_installation_id"
  value       = sensitive(base64decode(var.github_app_installation_id))
}