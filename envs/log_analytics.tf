/************************************************************
NameSpace
************************************************************/
resource "oci_log_analytics_namespace" "this" {
  compartment_id = var.tenancy_ocid
  is_onboarded   = true
  namespace      = var.namespace
}
