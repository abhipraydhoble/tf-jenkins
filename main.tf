resource "aws_instance" "vm" {
  ami           = "ami-0543dbdaf4e114be7"
  instance_type = "t3.micro"
  key_name      = "id_rsa"
  tags = {
    Name = "tf-server"
  }
}
