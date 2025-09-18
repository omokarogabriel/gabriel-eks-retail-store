##dynamoDB table
resource "aws_dynamodb_table" "dynamodb" {
  name                              = var.dynamodb_name
  billing_mode                      = "PAY_PER_REQUEST"
  hash_key                          = "dynamo_id"

  attribute {
    name                            = "${var.dynamodb_name}_id"
    type                            = "S"
  }

  tags = {
    Name                            = "${var.vpc_name}-rds-subnet-group"
  }

}