output "application_log_group_name" {
  value = aws_cloudwatch_log_group.application.name
}

output "high_node_cpu_alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_node_cpu.alarm_name
}

output "high_node_memory_alarm_name" {
  value = aws_cloudwatch_metric_alarm.high_node_memory.alarm_name
}
