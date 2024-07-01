
provider "aws" {

  region = "us-east-1"

}
 
terraform {

  backend "s3" {

    bucket         = "buckterra"

    key            = "./terraform.tfstate.d" 

    region         = "us-east-1"

    encrypt        = true

  }

}
 
# Define different values based on the workspace

locals {

  environment        = terraform.workspace

  bucket_name        = terraform.workspace == "prod" ? "prod-example-bucket" : "dev-example-bucket"

  instance_type      = terraform.workspace == "prod" ? "t2.small" : "t2.micro"

  db_instance_id     = "${terraform.workspace}-db-instance"

  db_name            = terraform.workspace == "prod" ? "prod_db" : "dev_db"

  db_username        = terraform.workspace == "prod" ? "prod_user" : "dev_user"

  db_password        = terraform.workspace == "prod" ? "prod_password" : "dev_password"

  db_instance_class  = terraform.workspace == "prod" ? "db.t3.small" : "db.t3.micro"  # Updated instance class

}
 
resource "aws_instance" "example" {

  ami           = "ami-01b799c439fd5516a"  # Amazon Linux 2 AMI

  instance_type = local.instance_type

  tags = {

    Name        = "${local.environment}-example-instance"

    Environment = local.environment

  }

}
 
# Security Group for RDS

resource "aws_security_group" "rds_sg" {

  name        = "${local.environment}-rds-sg"

  description = "Allow RDS traffic"

  ingress {

    from_port   = 3306

    to_port     = 3306

    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0

    to_port     = 0

    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {

    Name = "${local.environment}-rds-sg"

  }

}
 
# RDS instance

resource "aws_db_instance" "example" {

  identifier              = local.db_instance_id

  engine                  = "mysql"

  engine_version          = "8.0.35"

  instance_class          = local.db_instance_class

  db_name                 = local.db_name

  username                = local.db_username

  password                = local.db_password

  allocated_storage       = 20

  skip_final_snapshot     = true

  deletion_protection     = false

  publicly_accessible     = false

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  tags = {

    Name        = "${local.environment}-example-db"

    Environment = local.environment

  }

}
 