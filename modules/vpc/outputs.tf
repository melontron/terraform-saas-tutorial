output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnets" {
  value = ["${aws_subnet.us-east-1a-public.id}","${aws_subnet.us-east-1b-public.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.us-east-1a-private.id}","${aws_subnet.us-east-1b-private.id}"]
}




