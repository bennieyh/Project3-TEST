resource "aws_dynamodb_table" "score_board" {
  name           = "Team-Sequioa"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserName"
  range_key      = "HighScore"

  attribute {
    name = "UserName"
    type = "S"
  }

  attribute {
    name = "HighScore"
    type = "N"
  }

  stream_enabled      = false
  stream_view_type    = "NEW_IMAGE"

  ttl {
    attribute_name = "ExpirationTime"
    enabled        = false
  }

  global_secondary_index {
    name               = "HighScoreIndex"
    hash_key           = "HighScore"
    range_key          = "UserName"
    write_capacity     = 20
    read_capacity      = 20
    projection_type    = "ALL"
    non_key_attributes = []
  }
}
