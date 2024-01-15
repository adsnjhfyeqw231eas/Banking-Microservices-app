provider "aws" {
  profile = "default"
}

resource "aws_instance" "jenkins" {
  instance_type = "t2.medium"
  ami           = "ami-06aa3f7caf3a30282"
  count         = 1
  vpc_security_group_ids = ["sg-0845bad5c6caabd01"]
  key_name      = "new"
  user_data     = file("userdata.sh")


  tags = {
    Name    = "Jenkins"
    project = "CitiBank"
  }
}


