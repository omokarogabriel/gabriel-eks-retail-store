##dynamoDB table
resource "aws_dynamodb_table" "dynamodb" {
  name                              = var.dynamodb_name
  billing_mode                      = "PAY_PER_REQUEST"
  hash_key                          = "dynamo_id"

  attribute {
    name                            = "dynamo_id"
    type                            = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name                            = "${var.vpc_name}-dynamodb-table"
  }

}