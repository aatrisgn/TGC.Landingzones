data "scaleway_iam_application" "this_app" {
  name = "landingzone-spn"
}

data "scaleway_iam_group" "administrators" {
  group_id = "92226d68-4a75-4c11-8d00-3b26a6ebdd3e"
}

