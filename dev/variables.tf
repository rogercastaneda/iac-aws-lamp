variable "DB_USER" {
  type = string
}
variable "DB_PASSWORD" {
  type      = string
  sensitive = true
}
variable "DB_NAME" {
  type = string
}
variable "vpc_id" {
  description = "VPC ID"
}
variable "key_name" {
  description = "VPC ID"
}
variable "web_instance_type" {
  type = string
}
variable "db_instance_type" {
  type = string
}
variable "domain" {
  type = string
}
