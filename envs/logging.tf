# /************************************************************
# Log Group
# ************************************************************/
# ### Regional WAF
# resource "oci_logging_log_group" "this" {
#   compartment_id = oci_identity_compartment.workload.id
#   display_name   = "regional-waf-log-group"
#   description    = "For Regional WAF Log Group"
#   defined_tags   = local.common_defined_tags
# }

# /************************************************************
# Logs
# ************************************************************/
# ### Regional WAF
# resource "oci_logging_log" "this" {
#   display_name = "waf-all-log"
#   is_enabled   = true
#   log_type     = "SERVICE"
#   configuration {
#     compartment_id = oci_identity_compartment.workload.id
#     source {
#       source_type = "OCISERVICE"
#       service     = "waf"
#       category    = "all"
#       resource    = oci_waf_web_app_firewall.this.id
#       parameters  = {}
#     }
#   }
#   log_group_id       = oci_logging_log_group.this.id
#   retention_duration = 30
#   defined_tags       = local.common_defined_tags
# }