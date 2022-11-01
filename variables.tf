variable "project_id" {
  type        = string
  description = "(Required) The GCP project's id."
}

variable "region" {
  type        = string
  description = "(Required) The GCP project's region."
}

variable "zone" {
  type        = string
  description = "(Required) The GCP project's zone."
}

variable "project_name" {
  type        = string
  description = "(Required) Project readable name user for naming resources"
}

variable "domains" {
  type        = list(string)
  description = "(Required) Website domains names"
}


