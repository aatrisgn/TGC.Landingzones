variable "root_domains" {
  description = "List of root domains"
  type        = list(string)
}

variable "childzone_environments" {
  description = "List of environments for which to create childzones"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}