#Define the region
#lambda function creation Shrek-get
resource "aws_lambda_function" "ShrekGet" {
  function_name = "ShrekGet"
  filename      = "ShrekGet.zip"
  role          = aws_iam_role.ShrekGetRole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

##Lambda IAM policy Shrek-get
resource "aws_iam_role" "ShrekGetRole" {
  name = "ShrekGetRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dbReadAttach" {
  role       = aws_iam_role.ShrekGetRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ShrekGetBasicExecutionRole" {
  role       = aws_iam_role.ShrekGetRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#lambda function creation Shrek push
resource "aws_lambda_function" "ShrekPut" {
  function_name = "ShrekPut"
  filename      = "ShrekPut.zip"
  role          = aws_iam_role.ShrekPutRole.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

##Lambda IAM policy Shrek-push
resource "aws_iam_role" "ShrekPutRole" {
  name = "ShrekPutRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ShrekPutDBExec" {
  role       = aws_iam_role.ShrekPutRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

resource "aws_iam_role_policy_attachment" "ShrekPutBasicExecutionRole" {
  role       = aws_iam_role.ShrekPutRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}