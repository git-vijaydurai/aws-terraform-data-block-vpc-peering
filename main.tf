# Data destination to fetch existing VPCs


data "aws_vpc" "source_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.source_vpc_name}"]
  }

}

data "aws_vpc" "destination_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.destination_vpc_name}"]
  }

}


resource "aws_vpc_peering_connection" "source_to_destination_vpc_peering" {
  vpc_id      = data.aws_vpc.source_vpc.id
  peer_vpc_id = data.aws_vpc.destination_vpc.id
  auto_accept = true
  tags = {
    Name = "${var.source_vpc_name}_to_${var.destination_vpc_name}_peering"
  }
}


data "aws_route_table" "source_vpc_route_table" {

  filter {
    name   = "tag:Name"
    values = ["${var.source_vpc_route_table_name}"]
  }

}

data "aws_route_table" "destination_vpc_route_table" {
  filter {
    name   = "tag:Name"
    values = ["${var.destination_vpc_route_table_name}"]
  }
}


resource "aws_route" "route_source_vpc_to_destination_vpc" {
  route_table_id            = data.aws_route_table.source_vpc_route_table.id
  destination_cidr_block    = data.aws_vpc.destination_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.source_to_destination_vpc_peering.id
}

resource "aws_route" "route_destination_vpc_to_source_vpc" {
  route_table_id            = data.aws_route_table.destination_vpc_route_table.id
  destination_cidr_block    = data.aws_vpc.source_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.source_to_destination_vpc_peering.id
}
