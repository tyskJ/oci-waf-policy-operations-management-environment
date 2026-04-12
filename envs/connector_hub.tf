/************************************************************
Connector Hub
************************************************************/
### Logging to LogAnalytics
resource "oci_sch_service_connector" "all_log" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "waf-all-logging-to-loganalytics"
  state          = "ACTIVE" # ACTIVE or INACTIVE
  source {
    kind = "logging"
    log_sources {
      compartment_id = oci_logging_log_group.this.compartment_id
      log_group_id   = oci_logging_log_group.this.id
      log_id         = oci_logging_log.this.id
    }
  }
  target {
    batch_rollover_size_in_mbs = 0
    batch_rollover_time_in_ms  = 0
    batch_size_in_kbs          = 0
    batch_size_in_num          = 0
    batch_time_in_sec          = 0
    enable_formatted_messaging = false
    kind                       = "loggingAnalytics"
    log_group_id               = oci_log_analytics_log_analytics_log_group.this.id
  }
}

### Logging to Notifications
resource "oci_sch_service_connector" "check_and_block_notifications" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "waf-check-and-block-logging-to-notifications"
  state          = "ACTIVE" # ACTIVE or INACTIVE
  source {
    kind = "logging"
    log_sources {
      compartment_id = oci_logging_log_group.this.compartment_id
      log_group_id   = oci_logging_log_group.this.id
      log_id         = oci_logging_log.this.id
    }
  }
  tasks {
    batch_size_in_kbs = 0
    batch_time_in_sec = 0
    condition         = "(data.action='block' and data.clientAddr='113.*') or (data.action='allow' and data.requestProtection.matchedRules='*')"
    kind              = "logRule"
  }
  target {
    batch_rollover_size_in_mbs = 0
    batch_rollover_time_in_ms  = 0
    batch_size_in_kbs          = 0
    batch_size_in_num          = 0
    batch_time_in_sec          = 0
    enable_formatted_messaging = true
    kind                       = "notifications"
    topic_id                   = oci_ons_notification_topic.notify.id
  }
}