variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in"
  type        = string
}

variable "key_name" {
  description = "The name of the EC2 Key Pair to associate with the instance"
  type        = string
}

variable "security_groups" {
    description = "The security groups to associate with the instance"
    type        = list(string)
}
