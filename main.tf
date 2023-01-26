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
	ami = "ami-0713d3979e1313780"
	#subnet_id = aws_subnet.publicsubnet.id
	subnet_id = module.vpc.subnetid
	instance_type = "t2.2xlarge"
        #vpc_security_group_ids = [aws_security_group.allow_all.id]
	vpc_security_group_ids = [module.vpc.sgid]
	associate_public_ip_address = "true"

	
        connection {
                type = "ssh"
                user = "root"
                #password = "12523!@%@#"
		password = var.sshpw
                host = self.public_ip
        }

        provisioner "remote-exec" {
                inline = [
                        "/root/webv1.sh",
                ]
        }

	tags = {
		Name = "Donuts"
	}
}
