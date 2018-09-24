variable "project" {
    type = "string"
    default = "jenkins-distributed-master"
}
variable "vpc_id" {}
variable "subnet_id" {}
variable "ami" {}
variable "instance_type" {
    type = "string"
    default = "t2.small"
}
variable "key_name" {}
variable "volume_size" {
    type = "string"
    default = 30
}