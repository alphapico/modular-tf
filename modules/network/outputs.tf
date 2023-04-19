output "vpc_id" {
  value = aws_vpc.charonium-vpc.id
}

output "public_subnet_id_1" {
  value = aws_subnet.charonium-public-subnet-1.id
}

output "public_subnet_id_2" {
  value = aws_subnet.charonium-public-subnet-2.id
}

output "security_group_id" {
  value = aws_security_group.charonium-sg.id
}
