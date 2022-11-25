#Create VPC
resource "aws_vpc" "sentinel-demo-vpc" {
  cidr_block = var.vpccidr
}

#Retrieve availability zones for subnet mapping
data "aws_availability_zones" "available" {
  state = "available"
}

#Create subnets for workloads and load balancers
resource "aws_subnet" "ext" {
  vpc_id            = aws_vpc.sentinel-demo-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.sentinel-demo-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "api" {
  vpc_id            = aws_vpc.sentinel-demo-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "cache" {
  vpc_id            = aws_vpc.sentinel-demo-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "payments" {
  vpc_id            = aws_vpc.sentinel-demo-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "data" {
  vpc_id            = aws_vpc.sentinel-demo-vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

#Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.sentinel-demo-vpc.id
}

#Create EIP for NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
}

#Create EIP for Web App External LB
resource "aws_eip" "ext" {
  vpc = true
}

#Create NAT Gateway
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.ext.id
  depends_on    = [aws_internet_gateway.gw]
}

#Create route table to internet gateway ##Use this for public subnets
resource "aws_route_table" "extroutetable" {
  vpc_id = aws_vpc.sentinel-demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

#Create route table to nat gateway ##Use this for private subnets
resource "aws_route_table" "natroutetable" {
  vpc_id = aws_vpc.sentinel-demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw.id
  }
}

#Associates default route for public subnets
resource "aws_route_table_association" "routeassociationext" {
  subnet_id      = aws_subnet.ext.id
  route_table_id = aws_route_table.extroutetable.id
}

#Associates default route for private subnets
resource "aws_route_table_association" "routeassociationweb" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.natroutetable.id
}

resource "aws_route_table_association" "routeassociationapi" {
  subnet_id      = aws_subnet.api.id
  route_table_id = aws_route_table.natroutetable.id
}

resource "aws_route_table_association" "routeassociationcache" {
  subnet_id      = aws_subnet.cache.id
  route_table_id = aws_route_table.natroutetable.id
}

resource "aws_route_table_association" "routeassociationpay" {
  subnet_id      = aws_subnet.payments.id
  route_table_id = aws_route_table.natroutetable.id
}

resource "aws_route_table_association" "routeassociationdata" {
  subnet_id      = aws_subnet.data.id
  route_table_id = aws_route_table.natroutetable.id
}
