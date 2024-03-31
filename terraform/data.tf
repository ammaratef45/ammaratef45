data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = [ "amazon" ]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/refresh/"
  output_path = "${path.module}/refresh/refresh.zip"
}