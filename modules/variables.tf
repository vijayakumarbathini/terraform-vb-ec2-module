variable "instance_type" {
  description = "value of instance type"
  default     = "t2.micro"
}

variable "instance_family" {
  description = "value of instance family"
  default     = "t2"
}

variable "ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = {
    "ssh" = {
      from_port   = 22
      to_port     = 22
      protocol    = "ssh"
      cidr_blocks = ["0.0.0.0/0"]
    },
    "http" = {
      from_port   = 80
      to_port     = 80
      protocol    = "http"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}