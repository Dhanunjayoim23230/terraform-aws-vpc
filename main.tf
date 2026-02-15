resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = merge(
    var.common_tags,
    var.vpc_tags,
    {
      Name = local.name
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
      Name = "${local.name}"
    }
  )
}

#expense-dev-public-subnet-us-east-1a
resource "aws_subnet" "public" {
  count                   = length(var.public_cidr_block)
  availability_zone       = local.azs_info[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.name}-public-subnet-${local.azs_info[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_cidr_block)
  availability_zone = local.azs_info[count.index]
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_block[count.index]


  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.name}-private-subnet-${local.azs_info[count.index]}"
    }
  )
}


resource "aws_subnet" "database" {
  count             = length(var.database_cidr_block)
  availability_zone = local.azs_info[count.index]
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_cidr_block[count.index]


  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
      Name = "${local.name}-database-subnet-${local.azs_info[count.index]}"
    }
  )
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-public-subnet-route"
    }
  )

}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-private-subnet-route"
    }
  )

}
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-databse-subnet-route"
    }
  )
}

resource "aws_eip" "main" {
  domain = "vpc"

}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}"
    }
  )
  depends_on = [aws_internet_gateway.igw]
}

  resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
resource "aws_route" "private" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }
 resource "aws_route" "database" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }

  resource "aws_route_table_association" "public" {
    count = length(var.public_cidr_block)
     route_table_id = aws_route_table.public.id
     subnet_id = aws_subnet.public[count.index].id 
  }

  resource "aws_route_table_association" "private" {
    count = length(var.private_cidr_block)
     route_table_id = aws_route_table.private.id
     subnet_id = aws_subnet.private[count.index].id 
  }

    resource "aws_route_table_association" "database" {
    count = length(var.database_cidr_block)
     route_table_id = aws_route_table.database.id
     subnet_id = aws_subnet.database[count.index].id 
  }
