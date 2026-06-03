resource "aws_cloudwatch_log_group" "application" {
  name              = "/aws/eks/${var.name}/application"
  retention_in_days = var.log_retention_days

  tags = merge(var.tags, {
    Name = "${var.name}-application-logs"
  })
}

resource "aws_cloudwatch_metric_alarm" "high_node_cpu" {
  alarm_name          = "${var.name}-eks-high-node-cpu"
  alarm_description   = "EKS node CPU utilization is above 80%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "node_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.cluster_name
  }

  tags = merge(var.tags, {
    Name     = "${var.name}-eks-high-node-cpu"
    Severity = "warning"
  })
}

resource "aws_cloudwatch_metric_alarm" "high_node_memory" {
  alarm_name          = "${var.name}-eks-high-node-memory"
  alarm_description   = "EKS node memory utilization is above 80%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "node_memory_utilization"
  namespace           = "ContainerInsights"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  treat_missing_data  = "notBreaching"

  dimensions = {
    ClusterName = var.cluster_name
  }

  tags = merge(var.tags, {
    Name     = "${var.name}-eks-high-node-memory"
    Severity = "warning"
  })
}
