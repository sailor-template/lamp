resource "aws_vpc" "{{.name}}_my_vpc" {
  cidr_block = var.{{.name}}_vpc_cidr    

  tags = {
    Name = var.{{.name}}_vpc_name 
  }
}


#---------
resource "aws_subnet" "{{.name}}_private_subnet1" {
  vpc_id            = aws_vpc.{{.name}}_my_vpc.id
  cidr_block        = var.{{.name}}_private_subnet1_cidr 
  availability_zone = var.{{.name}}_availability_zone1 

  tags = {
    Name = var.{{.name}}_subnet1_private
  }
}

resource "aws_subnet" "{{.name}}_private_subnet2" {
  vpc_id            = aws_vpc.{{.name}}_my_vpc.id
  cidr_block        = var.{{.name}}_private_subnet2_cidr 
  availability_zone = var.{{.name}}_availability_zone1 

  tags = {
    Name = var.{{.name}}_subnet2_private
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
    from_port   = var.{{.name}}_from_port 
    to_port     = var.{{.name}}_to_port 
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

data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}




resource "aws_instance" "{{.name}}_web-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.{{.name}}_instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.{{.name}}_generated_key.key_name
  subnet_id                   = aws_subnet.{{.name}}_public_subnet2.id
  vpc_security_group_ids      = [aws_security_group.{{.name}}_security_group.id]
  monitoring                  = true
  user_data = <<-EOL
    #!/bin/bash -xe
    sudo apt update
    sudo apt install -y apache2
    sudo apt install -y php7.4 php7.4-mysql php-common php7.4-cli php7.4-json php7.4-common php7.4-opcache libapache2-mod-php7.4
    sudo systemctl restart apache2
    sudo apt install mysql-server -y
    sudo systemctl start mysql.service
   EOL
  
  root_block_device {
    volume_size           = var.{{.name}}_volume_size
    delete_on_termination = false
  }

  tags = {
    Name = var.{{.name}}_name
  }
 depends_on = [
   aws_subnet.{{.name}}_public_subnet1
 ]
}

resource "tls_private_key" "{{.name}}_private_key" {
  algorithm = var.{{.name}}_ec2_algorithm 
  rsa_bits  = var.{{.name}}_ec2_rsa_bits 
}

resource "aws_key_pair" "{{.name}}_generated_key" {
  key_name   = var.{{.name}}_key_name
  public_key = tls_private_key.{{.name}}_private_key.public_key_openssh
  
}




resource "aws_lb" "{{.name}}_lb" {
  name               =  var.{{.name}}_lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.security_group.id]
  subnets            = [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id,]

  enable_deletion_protection = false

}

resource "aws_lb_target_group" "{{.name}}_target_group" {
  name     =  var.{{.name}}_lb_target_group_name
  port     = 80
  protocol =  var.{{.name}}_lb_protocol
  vpc_id   = aws_vpc.{{.name}}_my_vpc.id
}


resource "aws_lb_target_group_attachment" "{{.name}}_target_group_attachment" {
  target_group_arn = aws_lb_target_group.{{.name}}_target_group.arn
  target_id        = aws_instance.{{.name}}_web-server.id
  port             = 80
}

resource "aws_lb_listener" "{{.name}}_listener" {
  load_balancer_arn = aws_lb.{{.name}}_lb.arn
  port              = var.{{.name}}_lb_listener_port
  protocol          = var.{{.name}}_lb_listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.{{.name}}_target_group.id
  }
}

