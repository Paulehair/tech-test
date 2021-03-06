variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type"
}

variable "instance_ami" {
  type        = string
  description = "AMI to use with instances"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "Number of instances to deploy"
}

variable "instance_key_name" {
  type = string
  description = "AWS EC2 Key name to use"
}

variable "stage" {
  type = string
  default = "staging"
  description = "Stage in which app is deployed"
}