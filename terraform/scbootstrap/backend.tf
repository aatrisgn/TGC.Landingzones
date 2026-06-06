terraform {
  backend "local" {
    path = "local_state/local.terraform.tfstate"
  }
}
