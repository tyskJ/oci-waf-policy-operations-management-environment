/************************************************************
IAM Policy - For Log Analytics Enable
************************************************************/
resource "oci_identity_policy" "lgan_enable" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "These policies were automatically created when you were enabling Log Analytics."
  name           = "logging_analytics_automatic_service_policies"
  statements = [
    ### For Enabling Sample Logs
    # "define tenancy sampledata as ocid1.tenancy.oc1..aaaaaaaabmtv54v5bg45j7zd2eeat4df2bwfqkmxe2yy6ecdfrc36wloe4ia",
    # "endorse group Administrators to read loganalytics-features-family in tenancy sampledata",
    # "endorse group Administrators to read loganalytics-resources-family in tenancy sampledata",
    # "endorse group Administrators to read compartments in tenancy sampledata",
    ### For Enabling Log Analytics
    "allow service loganalytics to READ loganalytics-features-family in tenancy",
    "allow service loganalytics to READ compartments in tenancy",
  ]
  defined_tags = local.common_defined_tags
}

/************************************************************
IAM Policy - For Ingestion Audit Log
************************************************************/
resource "oci_identity_policy" "lgan_ingestion_auditlog" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "These policies were automatically created when you set up ingestion for Log Analytics"
  name           = "logging_analytics_automatic_ingestion_policies"
  statements = [
  ]
  defined_tags = local.common_defined_tags
}