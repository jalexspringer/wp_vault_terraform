#----- Route 53 -----

# Primary Zone

resource "aws_route53_zone" "primary" {
  name = "${var.domain_name}.net"
  delegation_set_id = "${var.delegation_set}"
}

# WWW Record

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name = "www.${var.domain_name}.net"
  type = "A"

  alias {
    name = "${aws_elb.wp_elb.dns_name}"
    zone_id = "${aws_elb.wp_elb.zone_id}"
    evaluate_target_health = false
  }
}

# Dev Record

resource "aws_route53_record" "dev" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name = "dev.${var.domain_name}.net"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.wp_dev.public_ip}"]
}

# Private Zone

resource "aws_route53_zone" "secondary" {
  name = "${var.domain_name}.net"
  vpc {
    vpc_id = "${aws_vpc.wp_vpc.id}"
  }
}

# DB Record

resource "aws_route53_record" "db" {
  zone_id = "${aws_route53_zone.secondary.zone_id}"
  name = "db.${var.domain_name}.net"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_db_instance.wp_db.address}"]
}
