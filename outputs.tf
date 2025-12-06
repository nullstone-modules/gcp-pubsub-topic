output "topic_id" {
  value       = google_pubsub_topic.this.id
  description = "string ||| The ID of the Pub/Sub topic. (Format: projects/{project}/topics/{name})"
}

output "topic_name" {
  value       = google_pubsub_topic.this.name
  description = "string ||| The name of the Pub/Sub topic."
}
