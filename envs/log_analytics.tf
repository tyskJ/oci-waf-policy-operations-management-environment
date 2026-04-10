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
  defined_tags   = local.common_defined_tags
}