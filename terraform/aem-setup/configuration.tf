provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}



resource "aws_instance" "terraform" {

root_block_device {
        volume_size = 80
}

# Copies all files and folders to /terraform/binaries
provisioner "file" {
source = "binaries-files/"
destination = "/tmp/"
}

 provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/bootstrap.sh",
          "/tmp/bootstrap.sh"
        ]
    }

provisioner "chef" {
environment = "_default"
server_url = "https://api.chef.io/organizations/egirdhar"
recreate_client = true
user_name = "egirdhar"
user_key = "${file("./egirdhar.pem")}"
node_name = "terraform"
run_list = [ "role[aem]" ]
version = "12.4.1"
}

connection {
type = "ssh"
#user = "root"
user = "ec2-user"
host = "${aws_instance.terraform.public_ip}"
Insecure = true
https = false
private_key = "${file("./aig_girdhar.pem")}"
}


instance_type = "t2.medium"
#ami = "ami-334fd324"

ami = "ami-c9bd2dde"
key_name = "${var.key_name}"



}


