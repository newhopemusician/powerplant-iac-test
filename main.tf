provider "aws" {
	region = var.region
}

module "network-module" {
  source  = "tf.lnxservices.com/springfieldpower-2024/network-module/powerplant"
  version = "0.0.2"
}

#module "vpc" {
#  source = "github.com/newhopemusician/powerplant-network-module"
#}

resource "aws_instance" "web" {
	ami = "ami-0dc2a3e45f57ea1c9"
	subnet_id = module.network-module.subnetid
	instance_type = "t2.small"
	vpc_security_group_ids = [module.network-module.sgid]

	tags = {
		Name = "Doh!"
	}
}

data "aws_eip" "bac_ip" {
	public_ip = "3.22.150.18"
}

resource "aws_eip_association" "bac_assoc" {
	instance_id = aws_instance.web.id
	allocation_id = data.aws_eip.bac_ip.id
}
