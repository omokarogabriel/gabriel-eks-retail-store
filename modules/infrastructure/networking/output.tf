####output for the vpc

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.retail_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.retail_vpc.cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.nat.id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table."
  value       = aws_route_table.private.id
}

output "public_route_table_association_ids" {
  description = "The IDs of the public route table associations."
  value       = aws_route_table_association.public[*].id
}

output "private_route_table_association_ids" {
  description = "The IDs of the private route table associations."
  value       = aws_route_table_association.private[*].id
}
