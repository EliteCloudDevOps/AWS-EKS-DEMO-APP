resource "aws_ecr_repository" "testapp_web" {
  name  = "testapp_web"
  image_scanning_configuration {
    scan_on_push = true
  }   
}

resource "aws_ecr_repository" "testapp_api" {
  name  = "testapp_api"
  image_scanning_configuration {
    scan_on_push = true
  }  
}

# resource "aws_ecr_repository" "testapp_web_base" {
#   name  = "testapp_web_base"
#   image_scanning_configuration {
#     scan_on_push = true
#   }   
# }

# resource "aws_ecr_repository" "testapp_api_base" {
#   name  = "testapp_api_base"
#   image_scanning_configuration {
#     scan_on_push = true
#   }  
# }