data "ns_connection" "notification" {
  name     = "notification"
  contract = "datastore/gcp/notification"
  optional = true
}

locals {
  notification_channels = try(data.ns_connection.notification.outputs.notification_channels, [data.ns_connection.notification.outputs.notification_name], [])
}

resource "google_monitoring_alert_policy" "unacked_message_age" {
  count = signum(length(local.notification_channels))

  display_name = "${local.resource_name}-unacked"
  combiner     = "OR"
  user_labels  = local.labels

  conditions {
    display_name = "oldest_unacked_message_age > ${var.alert_thresholds.message_age}s"

    condition_threshold {
      filter          = "resource.type = \"pubsub_topic\" AND resource.label.topic_id = \"${google_pubsub_topic.this.name}\" AND metric.type = \"pubsub.googleapis.com/topic/oldest_unacked_message_age_by_region\""
      comparison      = "COMPARISON_GT"
      threshold_value = var.alert_thresholds.message_age
      duration        = "300s"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MAX"
        cross_series_reducer = "REDUCE_MAX"
      }
    }
  }

  notification_channels = local.notification_channels

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "Pub/Sub topic ${google_pubsub_topic.this.name} has messages unacknowledged for more than ${var.alert_thresholds.message_age}s. A subscriber is falling behind or failing."
    mime_type = "text/markdown"
  }
}
