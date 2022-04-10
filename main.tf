
resource "aws_lightsail_instance" "mongodb_server" {
  name              = "mongodb1"
  availability_zone = "ca-central-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"
  key_pair_name     = "LightsailDefaultKeyPair"
  connection {
    type        = "ssh"
    user        = self.username
    host        = self.public_ip_address
    private_key = data.local_file.key_pair_file.content
  }
  provisioner "remote-exec" {
    inline = [
      "echo \"The server's IP address is ${self.private_ip_address}\"",
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y upgrade",
      "sudo apt-get install -y gnupg",
      "wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org"
    ]
  }
}

resource "aws_lightsail_static_ip_attachment" "mongodb_attachment" {
  static_ip_name = aws_lightsail_static_ip.mongodb_ip.id
  instance_name  = aws_lightsail_instance.mongodb_server.id
}

resource "aws_lightsail_static_ip" "mongodb_ip" {
  name = "${aws_lightsail_instance.mongodb_server.name}-ip"
}

