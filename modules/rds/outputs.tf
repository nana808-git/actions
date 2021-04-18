output "db_host" {
  value = aws_db_instance.db.address
}

output "db_endpoint" {
  value = "${aws_db_instance.db.address}"
}

