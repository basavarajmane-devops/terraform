resource "aws_instance" "webapp-instance1" {
  ami                         = "ami-0ca2e925753ca2fb4"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.webapp-sg.id]
  subnet_id                   = aws_subnet.webapp-subnet1.id
  key_name                    = "aws-personal-rsa"
  associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/basavaraj.mane/personal-aws/aws-personal-rsa.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }


  tags = {
    Name = "web1-instance"
  }

}

output "instance1_ip" {
  value       = aws_instance.webapp-instance1.public_ip
  description = "Ip address of webapp-instance1"
}

resource "aws_instance" "webapp-instance2" {
  ami                         = "ami-0ca2e925753ca2fb4"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.webapp-sg.id]
  subnet_id                   = aws_subnet.webapp-subnet2.id
  key_name                    = "aws-personal-rsa"
  associate_public_ip_address = true


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/basavaraj.mane/personal-aws/aws-personal-rsa.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install nginx",
      "sudo systemctl start nginx",
    ]
  }

  tags = {
    Name = "web2-instance"
  }

}

output "instance2_ip" {
  value       = aws_instance.webapp-instance2.public_ip
  description = "Ip address of webapp-instance1"
}

resource "aws_security_group" "webapp-sg" {

  name        = "webapp-sg"
  description = "security group for access web application"
  vpc_id      = aws_vpc.webapp-vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "webapp-access" {
  security_group_id = aws_security_group.webapp-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "80"
  ip_protocol       = "tcp"
  to_port           = "80"
}

resource "aws_vpc_security_group_ingress_rule" "ssh-access" {
  security_group_id = aws_security_group.webapp-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = "22"
  ip_protocol       = "tcp"
  to_port           = "22"
}

resource "aws_vpc_security_group_egress_rule" "all-traffic" {
  security_group_id = aws_security_group.webapp-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc" "webapp-vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "webapp"
  }
}

resource "aws_subnet" "webapp-subnet1" {
  vpc_id            = aws_vpc.webapp-vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    name = "webapp"
  }
}


resource "aws_subnet" "webapp-subnet2" {
  vpc_id            = aws_vpc.webapp-vpc.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    name = "webapp"
  }
}

resource "aws_internet_gateway" "webapp-igw" {
  vpc_id = aws_vpc.webapp-vpc.id

  tags = {
    Name = "webapp"

  }
}


resource "aws_route_table" "webapp-routetable" {
  vpc_id = aws_vpc.webapp-vpc.id

}

resource "aws_route" "webapp-route" {
  route_table_id         = aws_route_table.webapp-routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.webapp-igw.id
}

resource "aws_route_table_association" "webapp-route1" {
  subnet_id      = aws_subnet.webapp-subnet1.id
  route_table_id = aws_route_table.webapp-routetable.id
}

resource "aws_route_table_association" "webapp-route2" {
  subnet_id      = aws_subnet.webapp-subnet2.id
  route_table_id = aws_route_table.webapp-routetable.id
}
