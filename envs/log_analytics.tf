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
  namespace      = oci_log_analytics_namespace.this.namespace
}

/************************************************************
Purge Policy
************************************************************/
resource "oci_log_analytics_namespace_scheduled_task" "purge_log_schedule" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "purge-policy-waf-log-weekly"
  kind           = "STANDARD"
  namespace      = oci_log_analytics_namespace.this.namespace
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

/************************************************************
Local Exec
************************************************************/
### Create Label
resource "terraform_data" "local_exec_create_label" {
  depends_on = [
    oci_log_analytics_namespace.this
  ]
  provisioner "local-exec" {
    command = <<EOT
      oci log-analytics label upsert-label \
      --namespace-name ${var.namespace} \
      --display-name "Official IP" \
      --description "Official IP Label" \
      --type PROBLEM \
      --priority HIGH \
      --aliases '[
        {
          "alias": "#test",
          "aliasDisplayName": "test",
          "display-name": null,
          "is-system": false,
          "name": "#official_ip",
          "priority": null
        }
      ]' \
      --profile ADMIN \
      --auth security_token
    EOT
  }
}

/************************************************************
Ingestion Rule
************************************************************/
resource "oci_log_analytics_namespace_ingest_time_rule" "client_ip_block" {
  depends_on = [
    terraform_data.local_exec_create_label
  ]
  compartment_id = var.tenancy_ocid
  namespace      = var.namespace
  display_name   = "waf-official-ip-block-detection-rule"
  conditions {
    kind           = "FIELD"
    field_name     = "mtag"
    field_operator = "EQUAL"
    field_value    = "#official_ip"
    additional_conditions {
      condition_field    = "mtgttype"
      condition_operator = "EQUAL"
      condition_value    = "oci_webappfirewall"
    }
    additional_conditions {
      condition_field    = "SOURCE_NAME"
      condition_operator = "EQUAL"
      condition_value    = "ociWAFLogSource"
    }
  }
  actions {
    type           = "METRIC_EXTRACTION"
    compartment_id = oci_identity_compartment.workload.id
    namespace      = "custom_regional_waf"
    metric_name    = "block_official_ip"
    dimensions     = []
  }
}