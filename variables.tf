variable "{{.name}}_vpc_name" {
  description = "name of the vpc"
  type        = string
}

variable "{{.name}}_vpc_cidr" {
  description = "cidr block for vpc"
  type        = string
}
variable "{{.name}}_subnet1_private" {
  description = "name of the subnet1"
  type        = string
}

variable "{{.name}}_private_subnet1_cidr" {
  description = "name of the subnet1 cidr"
  type        = string
}
variable "{{.name}}_private_subnet2_cidr" {
  description = "name of the subnet2 cidr"
  type        = string
}


variable "{{.name}}_subnet2_private" {
  description = "name of the subnet2"
  type        = string
}



variable "{{.name}}_public_subnet1_cidr" {
  description = "cidr block for subnet"
  type        = string
}
variable "{{.name}}_subnet1_public" {
  description = "name of the subnet1"
  type        = string
}

variable "{{.name}}_availability_zone1" {
  description = "availability zone for the subnets"
  type        = string
}

variable "{{.name}}_availability_zone2" {
  description = "availability zone for the subnets"
  type        = string
}
variable "{{.name}}_public_subnet2_cidr" {
  description = "subnet2 cidr block"
  type        = string

}
variable "{{.name}}_subnet2_public" {
  description = "name of the subnet2"
  type        = string
}

variable "{{.name}}_security_group_name" {
  description = "name of the security group"
  type        = string
}

variable "{{.name}}_from_port" {
  description = "Enter the from port"
  type        = number
}

variable "{{.name}}_to_port" {
  description = "Enter the to port"
  type        = number
}

variable "{{.name}}_protocol" {
  description = "Enter the to protocol"
  type        = string
}



variable "{{.name}}_instance_type" {
  description = "The type of instance to start"
  type        = string


}

variable "{{.name}}_volume_size" {
  description = "Whether to create an instance Size of the root volume in gigabytes"
  type        = number

}

variable "{{.name}}_name" {
  description = "Name to be used on EC2 instance created"
  type        = string

}

variable "{{.name}}_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the aws_key_pair resource"
  type        = string

}

variable "{{.name}}_region" {
  description = "AWS Region the instance is launched in"
  type        = string
}

variable "{{.name}}_ec2_algorithm" {
  description = "Algorithm for private key in ec2"
  type        = string
  default     = "RSA"
}

variable "{{.name}}_ec2_rsa_bits" {
  description = "no of bits for rsa algorithm"
  type        = number
  default     = 4690
}



variable "{{.name}}_lb_listener_protocol" {
  description = "values for listener protocol"
  type        = string
}


variable "{{.name}}_lb_listener_port" {
  description = "values for listener port"
  type        = number
}
variable "{{.name}}_lb_protocol" {
  description = "values for lb protocol"
  type        = string
}

variable "{{.name}}_lb_target_group_name" {
  description = "values for lb target group name"
  type        = string
}

variable "{{.name}}_lb_name" {
  description = "values for lb name"
  type        = string
}
