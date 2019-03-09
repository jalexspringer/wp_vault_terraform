#----- Security Groups -----

# Public Sec Group
resource "aws_security_group" "wp_public_sg" {
  name = "wp_public_sg"
  description = "ELB public access"
  vpc_id = "${aws_vpc.wp_vpc.id}"

  # HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Dev access from local IP

resource "aws_security_group" "wp_dev_sg" {
  name = "wp_dev_sg"
  description = "Used for access to the dev instance"
  vpc_id = "${aws_vpc.wp_vpc.id}"

  # SSH Rules

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.localip}"]
  }

  # HTTP

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.localip}"]
  }

  egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }
}
# Access to entire VPC CIDR

resource "aws_security_group" "wp_private_sg" {
  name = "wp_private_sg"
  description = "Private network access to from VPC"
  vpc_id = "${aws_vpc.wp_vpc.id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# RDS Security Group

resource "aws_security_group" "wp_rds_sg" {
  name = "wp_rds_sg"
  description = "Restricted access for RDS instances"
  vpc_id = "${aws_vpc.wp_vpc.id}"

  ingress {
    to_port = 3306
    from_port = 3306
    protocol = "tcp"

    security_groups = ["${aws_security_group.wp_dev_sg.id}",
      "${aws_security_group.wp_public_sg.id}",
      "${aws_security_group.wp_private_sg.id}"
    ]
  }
}
