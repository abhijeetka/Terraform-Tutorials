resource "aws_db_subnet_group" "allow_rds_connect" {
  name       = "allow-rds-connect"
  subnet_ids = [aws_subnet.main_private.id, aws_subnet.main_private2.id]
  tags = {
    Name = "allow-rds-connect"
  }
}

resource "aws_db_parameter_group" "db_parameters" {
  name   = "maria-db-parameter-group"
  family = "mariadb10.1"
  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "maridadb" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.1.14"
  instance_class       = "db.t2.micro"
  identifier           = "mariadb"
  name                 = "mariadb"
  username             = "root"
  password             = "rootabhi123"
  db_subnet_group_name = aws_db_subnet_group.allow_rds_connect.id
  vpc_security_group_ids = [aws_security_group.connect_rds.id]
  parameter_group_name = "maria-db-parameter-group"
  multi_az             = "false"
  availability_zone    = aws_subnet.main_private.availability_zone
}
