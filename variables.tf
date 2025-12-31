variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "ec2_ami_id" {
  default = "ami-00ca570c1b6d79f36"
  type    = string
}

variable "ec2_root_volume_size" {
  default = 10
  type    = number
}

variable "env" {
  default = "dev"
  type    = string

}