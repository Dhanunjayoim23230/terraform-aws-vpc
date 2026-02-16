resource "aws_vpc_peering_connection" "name" {
count = var.is_peering_required ? 1:0
    vpc_id = aws_vpc.main.id #requestor
    peer_vpc_id = local.default_vpc_id #acceptor
    auto_accept = true

    tags = merge(
        var.common_tags,
        var.peering_tags,
        {
            Name: "${local.name}-default"
        }
    )
  
}

resource "aws_route" "public_peering" {
    count = var.is_peering_required ? 1 : 0
        route_table_id = aws_route_table.public.id
        vpc_peering_connection_id = aws_vpc_peering_connection.name[count.index].id
        destination_cidr_block = local.aws_vpc_default_cidr
}

resource "aws_route" "private_peering" {
    count = var.is_peering_required ? 1 : 0
        route_table_id = aws_route_table.private.id
        vpc_peering_connection_id = aws_vpc_peering_connection.name[count.index].id
        destination_cidr_block = local.aws_vpc_default_cidr
}

resource "aws_route" "database_peering" {
    count = var.is_peering_required ? 1 : 0
        route_table_id = aws_route_table.database.id
        vpc_peering_connection_id = aws_vpc_peering_connection.name[count.index].id
        destination_cidr_block = local.aws_vpc_default_cidr
}


resource "aws_route" "default_peering" {
    count = var.is_peering_required ? 1 : 0
        route_table_id = data.aws_route_table.default.id
        vpc_peering_connection_id = aws_vpc_peering_connection.name[count.index].id
        destination_cidr_block = aws_vpc.main.cidr_block
}
