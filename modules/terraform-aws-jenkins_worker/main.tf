data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # canonical
}

resource "aws_instance" "jenkins_workers" {
  for_each = var.ec2_vars
  ami           = data.aws_ami.ubuntu.id
  instance_type =  each.value.instance_type
  subnet_id =  each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids
  associate_public_ip_address = true
  key_name = each.value.key_name

  tags = {
    Name = each.value.tag_name
    Ansible = each.value.tag_ansible
  }
}
