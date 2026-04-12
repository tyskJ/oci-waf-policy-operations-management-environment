/************************************************************
Topics
************************************************************/
### 通知用
resource "oci_ons_notification_topic" "notify" {
  compartment_id = oci_identity_compartment.workload.id
  name           = "management-topic"
}

### Functions用
resource "oci_ons_notification_topic" "functions" {
  compartment_id = oci_identity_compartment.workload.id
  name           = "functions-topic"
}

/************************************************************
Subscriptions
************************************************************/
# トピックと同一コンパートメントにする必要あり
resource "oci_ons_subscription" "email" {
  compartment_id = oci_identity_compartment.workload.id
  topic_id       = oci_ons_notification_topic.notify.topic_id
  protocol       = "EMAIL"
  endpoint       = var.subscription_email
}