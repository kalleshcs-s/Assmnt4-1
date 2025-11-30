output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [for s in aws_subnet.subnets : s.id]
}

output "ec2_public_ip" {
  value       = aws_instance.ec2.*.public_ip
  description = "EC2 Public IP"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}
