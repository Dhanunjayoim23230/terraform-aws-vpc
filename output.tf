output "available_azs" {
  value = data.aws_availability_zones.az
}

output "aws_vpc" {
    value = data.aws_vpc.default
}

output "vpcid" {
    value = aws_vpc.main.id
  
}
output "igwid" {
    value = aws_internet_gateway.igw.id
  
}

# output "vpc_default_cidr" {
#     value = data.aws_vpc.default.cidr_block
# }

# output "default_vpc_cidr_block" {
#   description = "The CIDR block of the Default VPC"
#   value       = data.aws_vpc.default.cidr_block
# }

output "public_subnet_info" {
    value = aws_subnet.public
  
}
output "private_subnet_info" {
    value = aws_subnet.private
  
}
output "database_subnet_info" {
    value = aws_subnet.database
  
}