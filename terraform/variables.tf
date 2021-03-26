variable "master_type" {
  type    = string
  default = "t3.medium"
}
variable "worker_type" {
  type    = string
  default = "t2.micro"
}
variable "master_count" {
  # Forced to 1 if in single deployment mode
  type    = number
  default = 3
}
variable "worker_count" {
  # Forced to 0 if in single deployment mode
  type    = number
  default = 3
}
variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
variable "public_key_path" {
  type    = string
  default = "../outputs/keys/infra_rsa.pub"
}
variable "cluster_type" {
  type    = string
  default = "single"
  validation {
    condition     = var.cluster_type == "single" || var.cluster_type == "efs"
    error_message = "The cluster_type must be one of single, efs."
  }
}
variable "exposed_ports" {
  default = {}
}
