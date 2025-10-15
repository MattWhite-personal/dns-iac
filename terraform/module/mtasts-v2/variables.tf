variable "location" {
  type    = string
  default = "uksouth"
}

variable "domain-name" {
  type        = string
  description = "The domain MTA-STS/TLS-RPT is being deployed for."
}

variable "mtastsmode" {
  type        = string
  default     = "testing"
  description = "MTA-STS policy 'mode'. Either 'testing' or 'enforce'."

  validation {
    condition     = contains(["testing", "enforced"], lower(var.mtastsmode))
    error_message = "Only 'testing' or 'enforced' are accepted values."
  }
}

variable "max-age" {
  type        = number
  default     = 86400
  description = "MTA-STS max_age. Time in seconds the policy should be cached. Default is 1 day"

  validation {
    condition     = var.max-age >= 1 && var.max-age == floor(var.max-age)
    error_message = "The value must be a positive whole number (>= 1, no decimals)."
  }
}

variable "mx-records" {
  type        = list(string)
  description = "list of 'mx' records that should be included in mta-sts policy"
}

variable "reporting-email" {
  type        = string
  default     = "tls-rpt"
  description = "(Optional) Email to use for TLS-RPT reporting."

  validation {
    condition = can(
      regex(
        "^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,}$",
        lower(var.reporting-email)
      )
    )
    error_message = "The reporting-email must be a valid email address."
  }
}

variable "dns-resource-group" {
  type        = string
  description = "resource group that contains existing resources"
}

variable "afd-resource-group" {
  type        = string
  description = "resource group that contains existing resources"
}

variable "afd-version" {
  type        = string
  default     = "standard"
  description = "Azure Front Door version to use. Options are 'standard', 'premium'"
  validation {
    condition     = contains(["standard"], lower(var.afd-version))
    error_message = "Only 'standard' is an accepted values. Premium Support and Private Endpoints coming soon."
  }
}
variable "stg-resource-group" {
  type        = string
  description = "resource group that contains existing resources"
}

variable "use-existing-front-door" {
  type        = bool
  description = "true: have the module use an existing Azure Front Door instance, false: supply one as a variable"
  default     = false
}

variable "existing-front-door" {
  type        = string
  description = "CDN Profile to use if use-existing-cdn-profile is true"
  default     = ""

  validation {
    condition     = !(var.use-existing-front-door) || (length(trim(var.existing-front-door, " \t\n\r")) > 0)
    error_message = "existing_front_door must be set (non-empty) if use_existing_front_door is true."
  }
}
variable "resource-prefix" {
  type        = string
  description = "Prefix to use on resources"

}
variable "tags" {
  description = "Azure Resource tags to be added to all resources"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(trim(k, " \t\n\r")) > 0 && length(trim(v, " \t\n\r")) > 0
    ])
    error_message = "All tag keys and values must be non-empty strings."
  }
}

variable "runner-ip" {
  description = "IP address of the GitHub Actions runner"
  sensitive   = true
  type        = string
  default     = ""
}
