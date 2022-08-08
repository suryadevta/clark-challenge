
##########################################################
#creating vpc
#########################################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge({ Name = "clark-${var.env}" }, var.tags)
}

##########################################################
#creating internet gateway
#########################################################
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  #tags   = merge({ Name = "ush-${var.env}-igw-${var.az}" }, var.tags)
}

#resource "aws_eip" "nat" {
#  vpc = true
#  tags = merge({ Name = "ush-${var.env}-eip-natgw" }, var.tags)
#}

#resource "aws_nat_gateway" "nat_gateway" {
#  allocation_id = aws_eip.nat.id
#  subnet_id     = aws_subnet.public_subnet[0].id
#  tags          = merge({ Name = "ush-${var.env}-nat-${var.az}" }, var.tags)
#}

##########################################################
#creating 2 public subnets
#########################################################
resource "aws_subnet" "public_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index) #var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]            #var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "clark-${var.env}-Public" }, var.tags)
}

##########################################################
#creating 2 private subnets
#########################################################
resource "aws_subnet" "private_subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8,count.index+4) //sum([count.index, //length(var.availability_zones)])) #var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]                                                   #var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = merge({ Name = "clark-${var.env}-Private" }, var.tags)
}

##########################################################
#creating route tables
#########################################################
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  #tags   = merge({ Name = "ush-${var.env}-rt-public" }, var.tags)
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  #tags   = merge({ Name = "ush-${var.env}-rt-private" }, var.tags)
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

##########################################################
# Route table Association
#########################################################
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_main_route_table_association" "main_route_table" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.private_route_table.id
}