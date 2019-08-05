/*
  NAT Instance
*/
resource "aws_security_group" "nat" {
  name = "${var.env}-${var.project}-vpc-nat-sg"
  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = "${var.private_subnet_cidrs}"
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "${var.elasticache_port}"
    to_port = "${var.elasticache_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = "${var.elasticache_port}"
    to_port = "${var.elasticache_port}"
    protocol = "tcp"
    cidr_blocks = "${var.private_subnet_cidrs}"
  }


  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags = {
    Name = "NATSG"
    Terraform = "true"
  }
}

resource "aws_instance" "nat" {
  ami = "ami-00a9d4a05375b2763" # this is a special ami preconfigured to do NAT
  instance_type = "t2.nano"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat.id}"]
  subnet_id = "${var.nat_instnace_subnet}"
  associate_public_ip_address = true
  source_dest_check = false

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      user = "ec2-user"
      host = "${aws_instance.nat.public_dns}"
      private_key = "${file("${var.aws_key_path}")}"
    }

    inline = [
      "ELASTICACHE_ADDR=$(dig +short ${var.elasticache_host})",
      //"RDS_IP_ADDR=$(dig +short ${var.rds_host} | sed -e s/ec2[.[:alnum:]_-]*/''/  | tr '\n' ' ' | tr -d [:space:])",
      "sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport ${var.elasticache_port} -j DNAT --to $ELASTICACHE_ADDR:${var.elasticache_port}",
      //"sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport ${var.rds_port} -j DNAT --to $RDS_IP_ADDR:${var.rds_port}",
      "sudo service iptables save;",
      "export BOOL=${var.shutdown_after_setup} && if [ $BOOL -eq \"1\" ]; then sudo poweroff; fi"
    ]
  }

  tags = {
    Name = "${var.env}-${var.project} vpc NAT"
    Terraform = true
    Env = "${var.env}"
  }
}

resource "aws_eip" "nat" {
  count = "${var.assign_eip}"
  instance = "${aws_instance.nat.id}"
  vpc = true
}
