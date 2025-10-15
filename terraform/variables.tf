variable "repository" {
  type        = string
  description = "Github repository name"
  sensitive   = false
}
variable "runner-ip" {
  type        = string
  description = "IP address of the GitHub Actions runner"
  sensitive   = true
}