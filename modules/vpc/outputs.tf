output "vpc_id" {
  value = aws_vpc.main.tags_all
}

output "subnet_ids" {
  value = aws_subnet.public.*.id
}
