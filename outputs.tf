# Output for count
#  output "public_ip_address" {
#     value = aws_instance.my_instance[*].public_ip
# }

# output "private_ip_address" {
#     value = aws_instance.my_instance[*].private_ip #[*] This is ashrict used for count meta argument
# }

# Output for each
output "my_instance_Public_IP" {
  value = [
    for key in aws_instance.my_instance : key.public_ip
  ]
}

output "my_instance_PrivateIP" {
  value = [
    for key in aws_instance.my_instance : key.private_ip
  ]
}