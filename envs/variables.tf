variable "tenancy_ocid" {
  type = string
}

variable "namespace" {
  type = string
}

variable "loganalytics_onboard" {
  type    = bool
  default = true
}

variable "source_ip" {
  type = string
}

variable "subscription_email" {
  type = string
}

variable "work_user_ocid" {
  type = string
}

variable "repo_prefix" {
  type = string
}

variable "fn_name" {
  type = string
}