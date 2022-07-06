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

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "jenkins_workers" {
  for_each = var.ec2_vars
  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value.instance_type
  subnet_id = "subnet-09465c4cc7ae87791"
  vpc_security_group_ids = ["sg-0dfc4a6e9f9aea008"]
  associate_public_ip_address = true
  key_name = "TeamJenkins"
  

  tags = {
    Name = each.value.tag_name
    Ansible = each.value.tag_ansible
  }
}
