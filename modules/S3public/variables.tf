variable "domain" {
    type = string
}

variable "subdomain" {
    type = string
}

variable "alias" {
    type = string
    default = null
}

variable "custom404" {
    type = string
    default = null
}

variable "policy" {
    type = string
    default = null
}