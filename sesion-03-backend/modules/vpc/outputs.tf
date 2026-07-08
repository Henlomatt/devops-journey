output "vpc_id" {
  value = aws_vpc.main.id
}

output "security_group_id" {
  value = aws_security_group.allow_ssh.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}