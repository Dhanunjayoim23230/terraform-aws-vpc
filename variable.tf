#mandatory
variable "cidr_block" {

}

#optional
variable "project" {
default = {}

}

#optional
variable "environment" {
default = {}
}

variable "enable_dns_hostnames" {
  default = true

}

#optional
variable "common_tags" {
default = {}
}
#optional
variable "vpc_tags" {
default = {}
}
#optional
variable "igw_tags" {
default = {}
}

variable "azs_info" {

}
variable "public_cidr_block" {
 validation {
      condition = length(var.public_cidr_block) == 2
      error_message = "must pass 2 CIDR range for public "
    }

}

#optional
variable "public_subnet_tags" {
default = {}

}

#mandatory
variable "private_cidr_block" {
    validation {
      condition = length(var.private_cidr_block) == 2
      error_message = "must pass 2 CIDR range for private "
    }
}

variable "private_subnet_tags" {

}

variable "database_cidr_block" {
 validation {
      condition = length(var.database_cidr_block) == 2
      error_message = "must pass two cidr range for database "
    }

}

variable "database_subnet_tags" {

}
variable "is_peering_required" {
  default = false
}
variable "peering_tags" {
    default = {}
  
}