resource "aws_vpc" "{{.name}}_my_vpc" {
  cidr_block = var.{{.name}}_vpc_cidir    

  tags = {
    Name = var.{{.name}}_vpc_name 
  }
}


#---------
resource "aws_subnet" "{{.name}}_private_subnet1" {
  vpc_id            = aws_vpc.{{.name}}_my_vpc.id
  cidr_block        = var.{{.name}}_private_subnet1_cidir 
  availability_zone = var.{{.name}}_availability_zone1 

  tags = {
    Name = var.{{.name}}_subnet1_private
  }
}

resource "aws_subnet" "{{.name}}_private_subnet2" {
  vpc_id            = aws_vpc.{{.name}}_my_vpc.id
  cidr_block        = var.{{.name}}_private_subnet2_cidir 
  availability_zone = var.{{.name}}_availability_zone1 

  tags = {
    Name = var.{{.name}}_subnet2_private
  }
}
resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "{{.name}}_nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.{{.name}}_private_subnet1.id
  tags = {
    "Name" = "NatGateway1"
  }
}

resource "aws_nat_gateway" "{{.name}}_nat_gateway1" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.{{.name}}_private_subnet2.id
  tags = {
    "Name" = "NatGateway2"
  }
}
#---------
resource "aws_subnet" "{{.name}}_public_subnet1" {
  vpc_id            = aws_vpc.{{.name}}_my_vpc.id
  cidr_block        = var.{{.name}}_public_subnet1_cidir 
  availability_zone = var.{{.name}}_availability_zone1 

  tags = {
    Name = var.{{.name}}_subnet1_public
  }
}
resource "aws_subnet" "{{.name}}_public_subnet2" {
  vpc_id            = aws_vpc.{{.name}}_my_vpc.id
  cidr_block        = var.{{.name}}_public_subnet2_cidir 
  availability_zone = var.{{.name}}_availability_zone2 

  tags = {
    Name = var.{{.name}}_subnet2_public
  }
}
resource "aws_internet_gateway" "{{.name}}_internet-gateway" {
  vpc_id = aws_vpc.{{.name}}_my_vpc.id
  tags = {
    Name = "My-internet-gateway"
  }
}
resource "aws_route_table" "{{.name}}_rout-table" {
  vpc_id = aws_vpc.{{.name}}_my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.{{.name}}_internet-gateway.id
  }

  tags = {
    Name = "my-routing-table"
  }
}

#route table connect to public subnet
resource "aws_route_table_association" "{{.name}}_chaos-association" {
  subnet_id      = aws_subnet.{{.name}}_public_subnet2.id
  route_table_id = aws_route_table.{{.name}}_rout-table.id
}





resource "aws_security_group" "{{.name}}_security_group" {
  name   = var.{{.name}}_security_group_name  
  vpc_id = aws_vpc.{{.name}}_my_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.{{.name}}_form_port 
    to_port     = var.to_port 
    protocol    = var.{{.name}}_protocol 
    cidr_blocks = ["0.0.0.0/0"]

  }
    ingress {
    description = "TLS from VPC"
    from_port   = 443 
    to_port     = 443
    protocol    = var.{{.name}}_protocol 
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "TLS from VPC"
    from_port   = 1024
    to_port     = 65535
    protocol    = var.{{.name}}_protocol 
    cidr_blocks = [aws_vpc.{{.name}}_my_vpc.cidr_block]

  }
  egress {
    from_port = 0
    to_port =  0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}




resource "aws_instance" "{{.name}}_web-server" {
  ami                         = var.{{.name}}_ami
  instance_type               = var.{{.name}}_instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.{{.name}}_generated_key.key_name
  subnet_id                   = aws_subnet.{{.name}}_public_subnet2.id
  vpc_security_group_ids      = [aws_security_group.{{.name}}_security_group.id]
  monitoring                  = true
  user_data = <<-EOL
    #!/bin/bash -xe
    sudo apt update -y
    sudo apt install apache2 -y
    sudo apt install -y php
    sudo apt install -y php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip,intl}
    sudo systemctl restart apache2
    sudo mkdir test
    
  EOL
  
  root_block_device {
    volume_size           = var.{{.name}}_volume_size
    delete_on_termination = false
  }

  tags = {
    Name = var.{{.name}}_name
  }
 depends_on = [
   aws_subnet.public_subnet1
 ]
}

resource "tls_private_key" "{{.name}}_private_key" {
  algorithm = var.{{.name}}_ec2_algorithm 
  rsa_bits  = var.{{.name}}_ec2_rsa_bits 
}

resource "aws_key_pair" "{{.name}}_generated_key" {
  key_name   = var.{{.name}}_key_name
  public_key = tls_private_key.{{.name}}_private_key.public_key_openssh
    provisioner "local-exec" { # Create a "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ./key_name.pem"
    }
  
}


resource "aws_db_instance" "{{.name}}_default" {
  allocated_storage    = var.{{.name}}_allocated_storage
  db_name              = var.{{.name}}_db_name
  engine               = var.{{.name}}_db_engine
  engine_version       = var.{{.name}}_db_engine_version
  instance_class       = var.{{.name}}_db_instance_class
  username             = var.{{.name}}_db_user_name
  password             = var.{{.name}}_db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  max_allocated_storage = var.{{.name}}_db_max_storage
  vpc_security_group_ids = [aws_security_group.security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
}

resource "aws_db_subnet_group" "{{.name}}_subnet_group" {
  name       = "test"
  subnet_ids = [aws_subnet.{{.name}}_public_subnet1.id,{{.name}}_aws_subnet.public_subnet2.id]
}

