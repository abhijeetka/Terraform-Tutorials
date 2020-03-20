
resource "aws_key_pair" "nginx-deployer" {
      key_name = "ngixn-deploy"
      public_key = file(var.PATH_TO_PUBLIC_KEY)
  
}

resource "aws_instance" "nginx" {
  instance_type = "t2.micro"
  ami           = lookup(var.AMIS,var.AWS_REGION)
  key_name = aws_key_pair.nginx-deployer.key_name


  connection{
        type = "ssh"
        user = "ubuntu"
        private_key = file(var.PATH_TO_PRIVATE_KEY)
        host = self.public_ip
  }

  provisioner "file" {
        source = "script.sh"
        destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
        inline = [
              "sudo chmod +x /tmp/script.sh",
              "sudo sh /tmp/script.sh"
        ]
  }
}
