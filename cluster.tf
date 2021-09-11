
# resource "aws_instance" "ec2" {
#   count = 1
#   ami = "ami-04b9e92b5572fa0d1" # Ubuntu 18.04 LTS (64-bit x86)
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.public.id
#   associate_public_ip_address = true
#   key_name = aws_key_pair.ec2_key_pair.key_name
#   vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
# }

# resource "aws_security_group" "ec2_security_group" {
#   name        = "cluster-ec2-security-group"
#   vpc_id      = aws_vpc.primary.id
#   ingress {
#     from_port   = 6443
#     to_port     = 6443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# data "external" "install_control_plane" {
#   program = [
#     "bash", "install-control-plane.sh"
#   ]
#   query = {
#     k3s_ip = aws_instance.ec2[0].public_ip
#   }
# }

# # output "k3s_token" { value = data.external.install_control_plane.result.k3s_token }
# output "ec2_ips" { value = [for i in aws_instance.ec2: i.public_ip] }

# resource "tls_private_key" "ssh_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "ec2_key_pair" {
#   key_name   = "permanent-infra-ec2"
#   public_key = tls_private_key.ssh_key.public_key_openssh
# }

# resource "local_file" "ssh_private_key" {
#   filename = pathexpand("~/.ssh/permanent-infra-ec2.pem")
#   file_permission = "600"
#   directory_permission = "700"
#   sensitive_content = tls_private_key.ssh_key.private_key_pem
# }
