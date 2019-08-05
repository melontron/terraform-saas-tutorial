resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-${var.project}-vpc"
    Terraform = "true"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}



/*
  Public Subnet
*/
resource "aws_subnet" "us-east-1a-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${element(var.public_subnet_cidrs, 0)}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.project}.public.us-east-1a"
    Terraform = "true"
  }
}

resource "aws_subnet" "us-east-1b-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${element(var.public_subnet_cidrs, 1)}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.project}.public.us-east-1b"
    Terraform = "true"
  }
}

resource "aws_route_table" "us-east-1a-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.project}.public.us-east-1a"
    Terraform = "true"
  }
}

resource "aws_route_table" "us-east-1b-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "${var.project}.public.us-east-1b"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "us-east-1a-public" {
  subnet_id = "${aws_subnet.us-east-1a-public.id}"
  route_table_id = "${aws_route_table.us-east-1a-public.id}"
}

resource "aws_route_table_association" "us-east-1b-public" {
  subnet_id = "${aws_subnet.us-east-1b-public.id}"
  route_table_id = "${aws_route_table.us-east-1b-public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "us-east-1a-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${element(var.private_subnet_cidrs, 0)}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.project}.private.us-east-1a"
    Terraform = "true"
  }
}

resource "aws_subnet" "us-east-1b-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${element(var.private_subnet_cidrs, 1)}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.project}.private.us-east-1b"
    Terraform = "true"
  }
}

resource "aws_route_table" "us-east-1a-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${var.nat_instance_id}"
  }

  tags = {
    Name = "${var.project}.private.us-east-1a"
    Terraform = "true"
  }
}

resource "aws_route_table" "us-east-1b-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${var.nat_instance_id}"
  }

  tags = {
    Name = "${var.project}.private.us-east-1b"
    Terraform = "true"
  }
}

resource "aws_route_table_association" "us-east-1a-private" {
  subnet_id = "${aws_subnet.us-east-1a-private.id}"
  route_table_id = "${aws_route_table.us-east-1a-private.id}"
}

resource "aws_route_table_association" "us-east-1b-private" {
  subnet_id = "${aws_subnet.us-east-1b-private.id}"
  route_table_id = "${aws_route_table.us-east-1b-private.id}"
}
