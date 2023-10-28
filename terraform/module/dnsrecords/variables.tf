variable "zone_name" {
  description = "Name of the zone add to records to"
}

variable "rg_name" {
  description = "Name of the resource group to add the records"
}

variable "a-records" {
  description = "Records to attach to the domain"
  default     = []
}

variable "mx-records" {
  description = "MX Records for the domain"
  type = list(object({
    name = string
    ttl  = optional(number)
    records = list(object({
      preference = number
      exchange   = string
    }))
  }))
}

variable "cname-records" {
  description = "CNAME records for the domain"
  type = list(object({
    name       = string
    isAlias    = bool
    record     = optional(string)
    resourceID = optional(string)
    ttl        = optional(number)
  }))
  default = []
}

variable "caa-records" {
  description = "CAA records for the domain"
  type = list(object({
    name = string
    ttl  = optional(number)
    records = list(object({
      flags = number
      tag   = string
      value = string
    }))
  }))
}

variable "ttl" {
  type    = number
  default = 3600
}

variable "txt-records" {
  description = "Text records"
  type = list(object({
    name    = string
    ttl     = optional(number)
    records = set(string)
  }))
  default = []
}
