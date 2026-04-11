/************************************************************
NameSpace
************************************************************/
resource "oci_log_analytics_namespace" "this" {
  depends_on = [
    oci_identity_policy.lgan_enable
  ]
  compartment_id = var.tenancy_ocid
  is_onboarded   = var.loganalytics_onboard
  namespace      = var.namespace
  provisioner "local-exec" {
    when    = destroy
    command = <<EOT
      oci log-analytics namespace offboard \
      --namespace-name ${self.namespace} \
      --profile ADMIN \
      --auth security_token
    EOT
  }
}

/************************************************************
LogGroup
************************************************************/
resource "oci_log_analytics_log_analytics_log_group" "this" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "waf-log-group"
  description    = "For Regional WAF Log Group"
  namespace      = var.namespace
}

/************************************************************
Purge Policy
************************************************************/
resource "oci_log_analytics_namespace_scheduled_task" "purge_log_schedule" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "purge-policy-waf-log-weekly"
  kind           = "STANDARD"
  namespace      = var.namespace
  task_type      = "PURGE"
  action {
    purge_compartment_id      = var.tenancy_ocid
    compartment_id_in_subtree = true
    data_type                 = "LOG"
    purge_duration            = "-P7D"
    ### 'Log Group' = 'waf-log-group' でロググループ指定も可能
    query_string = "'Log Source' = 'OCI WAF Logs'"
    type         = "PURGE"
  }
  schedules {
    schedule {
      expression        = "0 0 11 ? * 1"
      misfire_policy    = "RETRY_INDEFINITELY"
      query_offset_secs = 0
      repeat_count      = 0
      time_zone         = "Asia/Tokyo"
      type              = "CRON"
    }
  }
}