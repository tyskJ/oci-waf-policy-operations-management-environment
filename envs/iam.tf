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
# resource "oci_identity_policy" "lgan_ingestion_auditlog" {
#   compartment_id = oci_identity_compartment.workload.id
#   description    = "These policies were automatically created when you set up ingestion for Log Analytics"
#   name           = "logging_analytics_automatic_ingestion_policies"
#   statements = [
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {EVENTRULE_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {LOAD_BALANCER_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {BUCKET_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to read functions-family in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to read api-gateway-family in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {VCN_READ, SUBNET_READ, VNIC_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {APPROVED_SENDER_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {IPSEC_CONNECTION_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {WEB_APP_FIREWALL_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to read operator-control-family in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {NETWORK_FIREWALL_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {DEVOPS_DEPLOYMENT_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {DEVOPS_DEPLOY_PIPELINE_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {DEVOPS_DEPLOY_STAGE_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {DEVOPS_BUILD_PIPELINE_READ, DEVOPS_BUILD_PIPELINE_STAGE_READ, DEVOPS_BUILD_RUN_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {APM_DOMAIN_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {SERVICE_CONNECTOR_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {DATAFLOW_APPLICATION_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {MEDIA_WORKFLOW_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {MEDIA_WORKFLOW_JOB_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {CLUSTER_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {GOLDENGATE_DEPLOYMENT_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {CG_DATA_SOURCE_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {POSTGRES_DB_SYSTEM_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {REDIS_CLUSTER_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to read agcs-instance in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {DIS_WORKSPACE_READ} in tenancy",
#     "allow resource loganalyticsvrp LogAnalyticsVirtualResource to {ADM_REMEDIATION_RECIPE_READ} in tenancy",
#     "allow any-user to {LOG_ANALYTICS_LOG_GROUP_UPLOAD_LOGS} in compartment id XXX where all {request.principal.type='serviceconnector', target.loganalytics-log-group.id='XXX', request.principal.compartment.id='XXX'}",
#   ]
#   defined_tags = local.common_defined_tags
# }