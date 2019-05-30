resource "aws_instance" "centos-vm01" {
  #ami           = "ami-090cbf775708a1421"
  ami ="${var.amis}"
  instance_type = "m4.xlarge"
  #subnet_id = "${aws_subnet.us-east-2a-public.id}"
  #vpc_security_group_ids = ["${aws_security_group.test_sg.id}"]
  #key_name = "${aws_key_pair.ec2key.key_name}"
  network_interface {
     network_interface_id       = "${aws_network_interface.default.id}"
     device_index               = 0
    }
  key_name = "terraform"
 tags {
  Name = "vThunder-vm01"
 }
}


output "ip" {
  value = "${aws_instance.centos-vm01.public_ip}"

}
