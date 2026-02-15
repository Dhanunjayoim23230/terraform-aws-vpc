output "available_azs" {
  value = data.aws_availability_zones.az
}

output "aws_vpc" {
    value = data.aws_vpc.default
}