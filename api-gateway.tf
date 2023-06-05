resource "aws_api_gateway_rest_api" "shrek" {
  name        = "Sequoia-proj3"
  description = "This is the Shrek API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

################################# GET ACTION #######################################

resource "aws_api_gateway_resource" "shrek_root" {
  rest_api_id = aws_api_gateway_rest_api.shrek.id
  parent_id   = aws_api_gateway_rest_api.shrek.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "GetMethod" {
  rest_api_id   = aws_api_gateway_rest_api.shrek.id
  resource_id   = aws_api_gateway_resource.shrek_root.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "Get200" {
  rest_api_id = aws_api_gateway_rest_api.shrek.id
  resource_id = aws_api_gateway_resource.shrek_root.id
  http_method = aws_api_gateway_method.GetMethod.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "GetInt" {
  rest_api_id             = aws_api_gateway_rest_api.shrek.id
  resource_id             = aws_api_gateway_resource.shrek_root.id
  http_method             = aws_api_gateway_method.GetMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.ShrekGet.invoke_arn
}

resource "aws_api_gateway_integration_response" "GetResponse200" {
  depends_on  = [aws_api_gateway_integration.GetInt]
  rest_api_id = aws_api_gateway_rest_api.shrek.id
  resource_id = aws_api_gateway_resource.shrek_root.id
  http_method = aws_api_gateway_method.GetMethod.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}





################################### PUT ACTION #################################

resource "aws_api_gateway_method" "PutMethod" {
  rest_api_id   = aws_api_gateway_rest_api.shrek.id
  resource_id   = aws_api_gateway_resource.shrek_root.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "Put200" {
  rest_api_id = aws_api_gateway_rest_api.shrek.id
  resource_id = aws_api_gateway_resource.shrek_root.id
  http_method = aws_api_gateway_method.PutMethod.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}
