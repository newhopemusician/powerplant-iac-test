provider "aws" {

	#region = var.region
	region = "us-east-2"

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
	ami = "ami-0a75701b4eba513a3"
	subnet_id = aws_subnet.publicsubnet.id
	instance_type = "t2.micro"
        vpc_security_group_ids = [aws_security_group.allow_all.id]
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

resource "aws_vpc" "Main" {                # Creating VPC here
  cidr_block       = var.main_vpc_cidr     # Defining the CIDR block use 10.0.0.0/24 for demo
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "IGW" {    # Creating Internet Gateway
   vpc_id =  aws_vpc.Main.id               # vpc_id will be generated after we create VPC
}

resource "aws_subnet" "publicsubnet" {    # Creating Public Subnets
  vpc_id =  aws_vpc.Main.id
  cidr_block = "${var.public_subnets}"        # CIDR block of public subnets
}

resource "aws_route_table" "defaultroute" {    # Creating RT for Public Subnet
   vpc_id =  aws_vpc.Main.id
   route {
      cidr_block = "0.0.0.0/0"               # Traffic from Public Subnet reaches Internet via Internet Gateway
      gateway_id = aws_internet_gateway.IGW.id
   }
}

resource "aws_route_table_association" "routeassoc" {
   subnet_id = aws_subnet.publicsubnet.id
   route_table_id = aws_route_table.defaultroute.id
}

resource "aws_eip" "nateIP" {
  vpc   = true
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.Main.id

  ingress {
    description      = "Allows all Traffic inbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_all"
  }
}
