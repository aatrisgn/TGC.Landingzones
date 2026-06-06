output "access_key_prd" {
  sensitive = true
  value = scaleway_iam_api_key.main["prd"].access_key
}

output "secret_key_prd" {
  sensitive = true
  value = scaleway_iam_api_key.main["prd"].secret_key
}

output "access_key_dev" {
  sensitive = true
  value = scaleway_iam_api_key.main["dev"].access_key
}

output "secret_key_dev" {
  sensitive = true
  value = scaleway_iam_api_key.main["dev"].secret_key
}