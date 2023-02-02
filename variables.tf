variable "ami" {
	default = "ami-0471021a4ee6bfcce"
}

variable "region" {
	default = "us-east-2"
}

variable "insttype" {
	default = "t2.small"
}

variable "main_vpc_cidr" {
	default = "10.0.0.0/24"
}

variable "public_subnets" {
	default = "10.0.0.128/26"
}

variable "private_subnets" {
	default = "10.0.0.192/26"
}



