provider "aws" {
	region = var.region
}

module "network-module" {
  source  = "github.com/simpsonhomerjay/terraform-powerplant-network-module"
  #version = "0.0.2"
}

resource "aws_instance" "web" {
	ami = "ami-0471021a4ee6bfcce"
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
