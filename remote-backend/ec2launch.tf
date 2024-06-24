
resource "aws_instance" "test_instance" {
  ami                    = "ami-0ca2e925753ca2fb4"
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  instance_type          = "t2.micro"

  tags = {
    name = "Test_Instance"
  }
}


resource "aws_security_group" "test_sg" {
  name        = "test-sg"
  description = "security group for access test application"
}

resource "aws_s3_bucket" "backend_bucket" {
  bucket              = "tf-backend-devops"
  bucket_prefix       = null
  force_destroy       = null
  object_lock_enabled = false
  tags = {
    Environment = "Test"
    Name        = "My-bucket"
  }
  tags_all = {
    Environment = "Test"
    Name        = "My-bucket"
  }
}
