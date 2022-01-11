/*terraform {
  required_providers {
      aws = {
          source = "hashicorp/aws"
          version = ">3.0,<3.70"
      }
  }
}*/
resource "aws_instance" "my-ec2" {
    ami = "ami-0ed9277fb7eb570c9"
    instance_type = var.instance-type
    key_name = "apple"
    vpc_security_group_ids = ["${aws_security_group.sample.id}"]
    count = 2
    tags = {
      Name = var.name[count.index]
    }
}
variable "name" {
  type = list(any)
  default = ["dev","test" ]
}
output "instance-publicip" {
  value = aws_instance.my-ec2[0].public_ip
}
resource "aws_security_group" "sample" {
    description = "this is a sample security group"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${aws_eip.eip-add.public_ip}/32"]
        
    }
}
output "security-group-dns" {
  value = aws_security_group.sample.arn
}
