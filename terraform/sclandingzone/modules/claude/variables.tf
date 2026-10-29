variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
  sensitive   = false
}

variable "github_app_private_key" {
  description = "GitHub App private key"
  type        = string
  sensitive   = true
}

variable "github_app_installation_id" {
  description = "GitHub App installation ID"
  type        = string
  sensitive   = true
}

variable "claude_code_oauth_token" {
  description = "OAuth token for Claude code access"
  type        = string
  sensitive   = true
}
