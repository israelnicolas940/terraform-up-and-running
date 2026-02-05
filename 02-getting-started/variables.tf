variable "server_port" {
  description = "Server port"
  type        = number
  default     = 8080
}

variable "lb_port" {
  description = "Load Balancer port"
  type        = number
  default     = 80
}
