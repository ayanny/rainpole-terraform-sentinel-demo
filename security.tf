#Create Security Groups for workloads
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.sentinel-demo-vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ANY
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.sentinel-demo-vpc.id

  ingress {
    description = "web ingress"
    from_port   = tonumber(var.webport)
    to_port     = tonumber(var.webport)
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ANY
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_api" {
  name        = "allow_api"
  description = "Allow api inbound traffic"
  vpc_id      = aws_vpc.sentinel-demo-vpc.id

  ingress {
    description = "api ingress"
    from_port   = tonumber(var.apiport)
    to_port     = tonumber(var.apiport)
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ANY
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_cache" {
  name        = "allow_cache"
  description = "Allow cache inbound traffic"
  vpc_id      = aws_vpc.sentinel-demo-vpc.id

  ingress {
    description = "cache ingress"
    from_port   = tonumber(var.cacheport)
    to_port     = tonumber(var.cacheport)
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ANY
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_payments" {
  name        = "allow_payments"
  description = "Allow payment inbound traffic"
  vpc_id      = aws_vpc.sentinel-demo-vpc.id

  ingress {
    description = "payment ingress"
    from_port   = tonumber(var.payport)
    to_port     = tonumber(var.payport)
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ANY
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_data" {
  name        = "allow_data"
  description = "Allow data inbound traffic"
  vpc_id      = aws_vpc.sentinel-demo-vpc.id

  ingress {
    description = "payment ingress"
    from_port   = tonumber(var.dataport)
    to_port     = tonumber(var.dataport)
    protocol    = "tcp"
    cidr_blocks = ["10.0.3.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #ANY
    cidr_blocks = ["0.0.0.0/0"]
  }
}