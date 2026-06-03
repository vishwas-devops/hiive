resource "datadog_monitor" "api_5xx_error_rate" {
  name    = "[CRITICAL] ${var.service_name} high 5xx error rate"
  type    = "query alert"
  message = <<EOT
High 5xx error rate detected for ${var.service_name}.

Impact: Users may be receiving failed API responses.
Priority: Critical

${var.alert_channel}
EOT

  query = "sum(last_5m):sum:trace.http.request.errors{env:${var.environment},service:${var.service_name}}.as_count() / sum:trace.http.request.hits{env:${var.environment},service:${var.service_name}}.as_count() > 0.05"

  monitor_thresholds {
    critical = 0.05
    warning  = 0.02
  }

  notify_no_data    = false
  renotify_interval = 30

  tags = [
    "env:${var.environment}",
    "service:${var.service_name}",
    "severity:critical",
    "team:platform"
  ]
}

resource "datadog_monitor" "api_p95_latency" {
  name    = "[CRITICAL] ${var.service_name} p95 latency above SLO"
  type    = "query alert"
  message = <<EOT
API p95 latency is above the defined SLO.

Impact: Platform may be degraded even if it is still online.
SLO: 95% of API requests should complete under 500ms.

${var.alert_channel}
EOT

  query = "avg(last_5m):p95:trace.http.request.duration{env:${var.environment},service:${var.service_name}} > 0.5"

  monitor_thresholds {
    critical = 0.5
    warning  = 0.3
  }

  notify_no_data    = false
  renotify_interval = 30

  tags = [
    "env:${var.environment}",
    "service:${var.service_name}",
    "severity:critical",
    "slo:latency",
    "team:platform"
  ]
}

resource "datadog_monitor" "kubernetes_deployment_unavailable" {
  name    = "[CRITICAL] Kubernetes deployment unavailable"
  type    = "query alert"
  message = <<EOT
A critical Kubernetes deployment has unavailable replicas.

Impact: One or more production services may be down.

${var.alert_channel}
EOT

  query = "max(last_5m):max:kubernetes_state.deployment.replicas_unavailable{env:${var.environment},kube_cluster_name:${var.eks_cluster_name}} by {kube_deployment} >= 1"

  monitor_thresholds {
    critical = 1
  }

  notify_no_data    = false
  renotify_interval = 30

  tags = [
    "env:${var.environment}",
    "cluster:${var.eks_cluster_name}",
    "severity:critical",
    "team:platform"
  ]
}

resource "datadog_monitor" "pod_restart_spike" {
  name    = "[CRITICAL] Kubernetes pod restart spike"
  type    = "query alert"
  message = <<EOT
Pod restart count is increasing rapidly.

Impact: Possible CrashLoopBackOff, bad deployment, config issue, or application runtime failure.

${var.alert_channel}
EOT

  query = "sum(last_10m):sum:kubernetes.containers.restarts{env:${var.environment},kube_cluster_name:${var.eks_cluster_name}} by {pod_name} > 5"

  monitor_thresholds {
    critical = 5
    warning  = 3
  }

  notify_no_data    = false
  renotify_interval = 30

  tags = [
    "env:${var.environment}",
    "cluster:${var.eks_cluster_name}",
    "severity:critical",
    "team:platform"
  ]
}

resource "datadog_monitor" "node_memory_saturation" {
  name    = "[CRITICAL] EKS node memory saturation"
  type    = "query alert"
  message = <<EOT
EKS node memory usage is critically high.

Impact: This can cause pod eviction and cascading service failures.

${var.alert_channel}
EOT

  query = "avg(last_5m):avg:kubernetes.memory.usage_pct{env:${var.environment},kube_cluster_name:${var.eks_cluster_name}} by {host} > 0.90"

  monitor_thresholds {
    critical = 0.90
    warning  = 0.80
  }

  notify_no_data    = false
  renotify_interval = 30

  tags = [
    "env:${var.environment}",
    "cluster:${var.eks_cluster_name}",
    "severity:critical",
    "team:platform"
  ]
}
