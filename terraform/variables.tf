variable "subscription_id" {
  type = string
  description = "Azure Subscription ID to connect to"
  sensitive = false
}
variable "client_id" {
    type = string
    description = "Client ID for Managed Identity to connect to Azure"
    sensitive = true
}

variable "client_secret" {
  type = string
  description = "Client Secret for Managed Identity"
  sensitive = true
}

variable "tenant_id" {
    type = string
    description = "GUID of the Azure Tenatnt to deploy to"
    sensitive = false
}