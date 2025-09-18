output "dynamodb_table_id" {
  description = "The ID of the DynamoDB table."
  value       = aws_dynamodb_table.dynamodb.id
}

output "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  value       = aws_dynamodb_table.dynamodb.name
}
