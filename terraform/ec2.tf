resource "aws_security_group" "strapi-sg" {
  vpc_id      = aws_vpc.strapi_vpc.id
  description = "Security Group for Strapi Application"
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {

    from_port   = "1337"
    to_port     = "1337"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Strapi-SG"
  }

}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] 
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["111151604484"] 
}

resource "aws_instance" "strapi-ec2" {
  ami                         = var.ami
  instance_type               = "t2.medium"
  vpc_security_group_ids      = [aws_security_group.strapi-sg.id]

  subnet_id                   = aws_subnet.public_subnet1.id

  key_name                    = "PEM-NV"
  associate_public_ip_address = true
  user_data                   = <<-EOF
                                #!/bin/bash
                                sudo apt update
                                curl -fsSL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
                                sudo bash -E nodesource_setup.sh
                                sudo apt update && sudo apt install nodejs -y
                                sudo npm install -g yarn && sudo npm install -g pm2
                                git clone -b arun https://github.com/ARUNKUMAAR-R/strapi.git
                                cd strapi
                                yarn start
                                pm2 start config/server.js --name strapi-server
                                pm2 save && pm2 startup                               
                                sleep 360
                                EOF

  tags = {
    Name = "Strapi_ec2"
  }
}

