# Create a Project for Landing Zone
resource "scaleway_account_project" "landing_zone_project" {
  for_each = { for env in local.environment_types : env => env }

  name        = "landing-zone-${each.value}"
  description = "Project for landing zone bootstrapping - ${each.value}"
}

resource "scaleway_iam_policy" "policy" {
  for_each = { for env in local.environment_types : env => env }
  
  name    = "object-storage-policy-${each.value}"
  application_id = data.scaleway_iam_application.this_app.id
  
  rule {
    project_ids          = [scaleway_account_project.landing_zone_project[each.key].id]
    permission_set_names = ["ObjectStorageFullAccess", "ObjectStorageBucketPolicyFullAccess"]
  }
}

resource "scaleway_object_bucket" "terraform_state_buckets" {
  for_each = { for env in local.environment_types : env => env }
  depends_on = [ scaleway_iam_policy.policy]

  name     = "${each.value}-bucket-tfstate-fr-par"
  region   = "fr-par"
  project_id = scaleway_account_project.landing_zone_project[each.key].id

  object_lock_enabled = true

  versioning {
    enabled = true
  }
}

resource "scaleway_iam_application" "landingzone_app" {
  for_each = { for env in local.environment_types : env => env }

  name        = "landingzone-${each.value}-spn"
  description = "Application used for landingzone setup - ${each.value}"
}

resource "scaleway_iam_group_membership" "member" {
  for_each = { for spn in scaleway_iam_application.landingzone_app : spn.name => spn }
  
  group_id       = data.scaleway_iam_group.administrators.id
  application_id = each.value.id
}

resource "scaleway_iam_api_key" "main" {
  for_each = { for env in local.environment_types : env => env }

  application_id = scaleway_iam_application.landingzone_app[each.key].id
  description    = "API key for landingzone application"
  default_project_id = scaleway_account_project.landing_zone_project[each.key].id
  expires_at = "2026-06-29T10:43:29Z"
}