data "scaleway_account_project" "default_project" {
  name = "landing-zone-${var.environment}"
}