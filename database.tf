#----- RDS ------

# Credential generation

resource "random_string" "username" {
  length = 16
  special = false
  number = false
  upper = false
}

resource "random_string" "password" {
  length = 16
  special = false
}

resource "aws_db_instance" "wp_db" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "${var.db_instance_class}"
  name = "${var.dbname}"
  username = "${random_string.username.result}"
  password = "${random_string.password.result}"
  db_subnet_group_name = "${aws_db_subnet_group.wp_rds_subnetgroup.name}"
  vpc_security_group_ids = ["${aws_security_group.wp_rds_sg.id}"]
  skip_final_snapshot = true
}
