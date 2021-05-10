variable "aws_region" {
  type    = string
  default = "us-west-1"
  description = "AWS Region Name"
}

variable "az1" {
  type    = string
  default = "us-west-1a"
  description = "AWS Availablity Zone 1a"
}

variable "az2" {
  type    = string
  default = "us-west-1c"
  description = "AWS Availablity Zone 1b"
}

variable "ami_id" {
  type    = string
  default = "ami-0d382e80be7ffdae5"
  description = "AWS ami ID"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
  description = "Instance Type"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
  description = "AWS Instance Type"
}

variable "device_name" {
  type    = string
  default = "/dev/sda1"
  description = "AWS device name"
}

variable "volume_size" {
  type    = number
  default = 8
  description = "AWS volume size"
}

variable "key_name" {
  type    = string
  default = "test-key"
  description = "AWS key name"
}

variable "cpu_credits" {
  type    = string
  default = "standard"
  description = "aws cpu credits"
}

variable "desired_capacity" {
  type    = string
  default = "2"
  description = "ASG Desired Capacity"
}

variable "health_check_grace_period" {
  type    = string
  default = "300"
  description = "ASG Health Check Grace Period"
}

variable "health_check_type" {
  type    = string
  default = "EC2"
  description = "ASG Health Check Type"
}

variable "max_size" {
  type    = string
  default = "2"
  description = "ASG Max Size"
}

variable "min_size" {
  type    = string
  default = "2"
  description = "ASG Min Size"
}
