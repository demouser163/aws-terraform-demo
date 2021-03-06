output "asg_desired_capacity" {
  value       = aws_autoscaling_group.test-asg.id
  description = "The desired capacity of the auto scaling group; it may be useful when doing blue/green asg deployment (create a new asg while copying the old's capacity)"
}

output "asg_name" {
  value       = aws_autoscaling_group.test-asg.name
  description = "The name of the auto scaling group"
}

output "aws_launch_configuration" {
  value       = aws_launch_configuration.test-lc.name
  description = "The name of the launch temconfiguration late used by the auto scaling group"
}