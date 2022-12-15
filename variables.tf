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

variable "{{.name}}_form_port" {
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


variable "{{.name}}_allocated_storage" {
  description = "values for allocated storage"
  type        = number
}

variable "{{.name}}_db_name" {
  description = "name of the db "
  type        = string
}

variable "{{.name}}_db_engine" {
  description = "engine type for db"
  type        = string
}

variable "{{.name}}_db_engine_version" {
  description = "engine version type for db"
  type        = string
}
variable "{{.name}}_db_instance_class" {
  description = "instance values for db"
  type        = string
}

variable "{{.name}}_db_user_name" {
  description = "name of the db user"
  type        = string
}

variable "{{.name}}_db_password" {
  description = "password for the db"
  type        = string
}

variable "{{.name}}_db_max_storage" {
  description = "values for the max storages"
  type        = number
}

