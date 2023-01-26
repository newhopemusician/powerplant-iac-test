provider "aws" {

	#region = var.region
	region = "us-east-2"

}

module "vpc" {
  source = "github.com/newhopemusician/powerplant-network"
}

data "aws_ami" "ami_name" {
	most_recent = true

	filter {
		name = "name"
		values = ["amzn2-ami-kernel-5.10-hvm-2.0.20221210.1-x86_64-gp2*"]
	}
}

resource "aws_instance" "web" {
	#ami = data.aws_ami.ami_name.id
	#ami = "ami-0a75701b4eba513a3"
	ami = "ami-0c14999c5deede9fe"
	#subnet_id = aws_subnet.publicsubnet.id
	subnet_id = module.vpc.subnetid
	instance_type = "t2.micro"
        #vpc_security_group_ids = [aws_security_group.allow_all.id]
	vpc_security_group_ids = [module.vpc.sgid]
	associate_public_ip_address = "true"

	tags = {
		Name = "Donuts"
	}
}
