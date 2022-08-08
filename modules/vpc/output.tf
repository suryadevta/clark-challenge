output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_public" {
  value = aws_subnet.public_subnet.*.id
}

output "subnet_public_aue1" {
  value = aws_subnet.public_subnet.0.id
}

