
resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.primary.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

