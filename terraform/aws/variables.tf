variable "prefix" {
  type = "string"
}

variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "zone_id" {
  type = "string"
}

variable "alb_subnet_ids" {
  type = "list"
}

variable "base_domain" {
  type = "string"
}

variable "ssl_cert_arn" {
  type        = "string"
  default     = ""
}