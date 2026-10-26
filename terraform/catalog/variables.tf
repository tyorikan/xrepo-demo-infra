variable "environment" {
  description = "Deployment environment name."
  type        = string
}

variable "catalog_cache_ttl" {
  description = "Cache TTL of catalog-service, in seconds."
  type        = string
}

variable "image_tag" {
  description = "Container image tag of catalog-service."
  type        = string
  default     = "latest"
}

variable "internal_zone_id" {
  description = "Private hosted zone for internal service names."
  type        = string
}

variable "catalog_db_endpoint" {
  description = "Endpoint of the catalog database, managed outside this root."
  type        = string
}

variable "execution_role_arn" {
  description = "Task execution role that reads the secrets."
  type        = string
}

variable "desired_count" {
  description = "Number of catalog-service tasks."
  type        = number
  default     = 2
}

variable "vpc_id" {
  description = "VPC of the service."
  type        = string
}

variable "cluster_arn" {
  description = "ECS cluster that runs the service."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets of the service."
  type        = list(string)
}

variable "service_security_group_id" {
  description = "Security group of the service."
  type        = string
}
