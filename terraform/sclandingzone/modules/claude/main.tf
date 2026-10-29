resource "github_actions_secret" "claude_code_oauth_token_secret" {
  repository  = var.repository_name
  secret_name = "claude_code_oauth_token"
  value       = sensitive(base64decode(var.claude_code_oauth_token))
}

resource "github_actions_secret" "github_app_private_key_secret" {
  repository  = var.repository_name
  secret_name = "app_private_key"
  value       = sensitive(base64decode(var.github_app_private_key))
}

resource "github_actions_secret" "github_app_installation_id_secret" {
  repository  = var.repository_name
  secret_name = "app_installation_id"
  value       = sensitive(base64decode(var.github_app_installation_id))
}

resource "github_issue_label" "claude_label" {
  repository = var.repository_name
  name       = "claude"
  color      = "FFA500"
}

resource "github_issue_label" "minor_change_label" {
  repository  = var.repository_name
  name        = "Eazzy"
  color       = "0026FF"
  description = "Minor change label. Should be used for small, non-breaking changes which requires few modifications"
}

resource "github_issue_label" "small_change_label" {
  repository  = var.repository_name
  name        = "GotItBruv"
  color       = "00FFF2"
  description = "Small change label. Should be used for changes that are slightly larger than minor changes but still non-breaking."
}

resource "github_issue_label" "medium_change_label" {
  repository  = var.repository_name
  name        = "LetsCook"
  color       = "44FF00"
  description = "Medium change label. Should be used for changes that are larger than small changes but still non-breaking."
}

resource "github_issue_label" "big_change_label" {
  repository  = var.repository_name
  name        = "WeBallin"
  color       = "FFD400"
  description = "Big change label. Should be used for significant changes that may have a larger impact but are still non-breaking."
}

resource "github_issue_label" "huge_change_label" {
  repository  = var.repository_name
  name        = "LetsRipFoSho"
  color       = "FF2C00"
  description = "Huge change label. Should be used for very large changes that may have a significant impact and are breaking."
}
