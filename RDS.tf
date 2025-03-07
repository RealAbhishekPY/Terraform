resource "aws_db_instance" "app_db" {
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  name                  = "mydb"
  username              = "dbadmin"
  password              = "securepassword"
  parameter_group_name  = "default.mysql5.7"
  multi_az              = false
  skip_final_snapshot   = true
}

resource "aws_security_group" "db" {
  name        = "rds_sg"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
