# /************************************************************
# Alarm
# ************************************************************/
# resource "oci_monitoring_alarm" "this" {
#   compartment_id = oci_identity_compartment.workload.id
#   display_name   = "log-analytics-storage-used-5gb-alarm"
#   is_enabled     = true
#   ### Metric description & Trigger rule
#   metric_compartment_id = var.tenancy_ocid
#   namespace             = "oci_logging_analytics"
#   query                 = "ActiveStorageUsed[15m].max() > 5" # 5GB
#   pending_duration      = "PT1M"
#   severity              = "WARNING"
#   body                  = "Log Analytics Active Storage Used greater than 5 GB. Please Check Log Analytics Storage."
#   ### Define alarm notifications
#   destinations       = [oci_ons_notification_topic.notify.id]
#   notification_title = "Log Analytics Active Storage Used greater than 5 GB"
#   ## Message grouping
#   is_notifications_per_metric_dimension_enabled = false
#   ## Message Format
#   message_format = "ONS_OPTIMIZED"
# }