resource "google_pubsub_topic" "this" {
  name   = local.resource_name
  labels = local.labels
}
