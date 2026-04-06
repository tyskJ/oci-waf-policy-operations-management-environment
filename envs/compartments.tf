/************************************************************
Compartment - workload
************************************************************/
resource "oci_identity_compartment" "workload" {
  compartment_id = var.tenancy_ocid
  name           = "oci-waf-policy-operations-management-environment"
  description    = "For OCI WAF Policy Operations Management Environment"
  enable_delete  = true
}