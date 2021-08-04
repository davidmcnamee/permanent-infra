
resource "aws_instance" "ec2" {
  count = 1
  ami = "ami-04b9e92b5572fa0d1" # Ubuntu 18.04 LTS (64-bit x86)
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  key_name = aws_key_pair.ec2_key_pair.key_name
}

output "ec2_ips" { value = [for i in aws_instance.ec2: i.public_ip] }

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "permanent-infra-ec2"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_file" "ssh_private_key" {
  filename = pathexpand("~/.ssh/permanent-infra-ec2.pem")
  file_permission = "600"
  directory_permission = "700"
  sensitive_content = tls_private_key.ssh_key.private_key_pem
}
