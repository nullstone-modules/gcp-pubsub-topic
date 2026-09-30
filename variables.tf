variable "alert_thresholds" {
  type = object({
    message_age = optional(number, 600)
  })
  default     = {}
  description = <<EOF
Thresholds for alert policies on the topic. Only active when a notification connection is provided.
- message_age: Age (in seconds) of the oldest unacked message on the topic to trigger the alert (default: 600s)
EOF
}
