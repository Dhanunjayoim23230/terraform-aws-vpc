locals {
  name     = "${var.project}-${var.environment}"
  azs_info = slice(data.aws_availability_zones.az.names, 0, 2)
  default_vpc_id=data.aws_vpc.default.id
  aws_vpc_default_cidr = data.aws_vpc.default.cidr_block
}