variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "new_subscription_id" {
  description = "new migration id"
  type        = string
  sensitive   = true
}

variable "old_subscription_id" {
  description = "old migration id"
  type        = string
  sensitive   = true
}