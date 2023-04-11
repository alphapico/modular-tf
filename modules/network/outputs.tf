output "public_subnet_id" {
  value = aws_subnet.charonium-public-subnet-1.id
}

output "security_group_id" {
  value = aws_security_group.charonium-sg.id
}
