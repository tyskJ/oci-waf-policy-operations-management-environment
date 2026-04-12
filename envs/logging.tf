/************************************************************
Log Group
************************************************************/
### Regional WAF
resource "oci_logging_log_group" "this" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "regional-waf-log-group"
  description    = "For Regional WAF Log Group"
}

### Functions application
resource "oci_logging_log_group" "functions_application" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "functions-log-group"
  description    = "For Functions Log Group"
}

/************************************************************
Logs
************************************************************/
### Regional WAF
resource "oci_logging_log" "this" {
  display_name = "waf-all-log"
  is_enabled   = true
  log_type     = "SERVICE"
  configuration {
    compartment_id = oci_identity_compartment.workload.id
    source {
      source_type = "OCISERVICE"
      service     = "waf"
      category    = "all"
      resource    = oci_waf_web_app_firewall.this.id
      parameters  = {}
    }
  }
  log_group_id       = oci_logging_log_group.this.id
  retention_duration = 30
}

### Functions application
resource "oci_logging_log" "functions_application" {
  display_name = "invoke-logs"
  is_enabled   = true
  log_type     = "SERVICE"
  configuration {
    compartment_id = oci_identity_compartment.workload.id
    source {
      source_type = "OCISERVICE"
      service     = "functions"
      category    = "invoke"
      resource    = oci_functions_application.this.id
      parameters  = {}
    }
  }
  log_group_id       = oci_logging_log_group.functions_application.id
  retention_duration = 30
}