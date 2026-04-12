/************************************************************
Dynamic Group - Log Analytics Scheduled Task
************************************************************/
# 「oci_identity_dynamic_group」を使用する場合はルートコンパートメントのDefaultアイデンティティドメインにしか作成できない
# 「oci_identity_domains_dynamic_resource_group」を使用すれば、指定のアイデンティティドメインに作成可能
resource "oci_identity_dynamic_group" "lgan_sch" {
  compartment_id = var.tenancy_ocid
  name           = "Log_Analytics_Scheduled_Task"
  description    = "Log Analytics Scheduled Task"
  matching_rule = format(
    "ALL {resource.type='loganalyticsscheduledtask', resource.compartment.id='%s'}",
    oci_identity_compartment.workload.id
  )
}

/************************************************************
IAM Policy - For Log Analytics Enable
************************************************************/
resource "oci_identity_policy" "lgan_enable" {
  compartment_id = var.tenancy_ocid
  description    = "These policies were automatically created when you were enabling Log Analytics."
  name           = "logging_analytics_automatic_service_policies"
  statements = [
    ### For Enabling Sample Logs
    "define tenancy sampledata as ocid1.tenancy.oc1..aaaaaaaabmtv54v5bg45j7zd2eeat4df2bwfqkmxe2yy6ecdfrc36wloe4ia",
    "endorse group Administrators to read loganalytics-features-family in tenancy sampledata",
    "endorse group Administrators to read loganalytics-resources-family in tenancy sampledata",
    "endorse group Administrators to read compartments in tenancy sampledata",
    ### For Enabling Log Analytics
    "allow service loganalytics to READ loganalytics-features-family in tenancy",
    "allow service loganalytics to READ compartments in tenancy",
    ### For Push Metrics From Label
    # "allow service loganalytics to use metrics in tenancy",
  ]
}

/************************************************************
IAM Policy - For Ingestion Audit Log
************************************************************/
# resource "oci_identity_policy" "lgan_ingestion_auditlog" {
#   compartment_id = var.tenancy_ocid
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
# }

/************************************************************
IAM Policy - For Log Analytics Storage Purge Policy
************************************************************/
resource "oci_identity_policy" "lgan_purge" {
  compartment_id = var.tenancy_ocid
  description    = "These policies were Purge Log Analytics Storage."
  name           = "allow-log-analytics-purge-policy"
  statements = [
    format(
      "allow dynamic-group %s to read compartments in tenancy",
      oci_identity_dynamic_group.lgan_sch.name
    ),
    format(
      "allow dynamic-group %s to {LOG_ANALYTICS_STORAGE_PURGE} in tenancy",
      oci_identity_dynamic_group.lgan_sch.name
    ),
    format(
      "allow dynamic-group %s to {LOG_ANALYTICS_STORAGE_WORK_REQUEST_CREATE} in tenancy",
      oci_identity_dynamic_group.lgan_sch.name
    ),
    format(
      "allow dynamic-group %s to {LOG_ANALYTICS_LOG_GROUP_DELETE_LOGS} in tenancy",
      oci_identity_dynamic_group.lgan_sch.name
    ),
    format(
      "allow dynamic-group %s to {LOG_ANALYTICS_QUERY_VIEW} in tenancy",
      oci_identity_dynamic_group.lgan_sch.name
    ),
    format(
      "allow dynamic-group %s to {LOG_ANALYTICS_QUERYJOB_WORK_REQUEST_READ} in tenancy",
      oci_identity_dynamic_group.lgan_sch.name
    )
  ]
}

/************************************************************
IAM Policy - For Connector Hub
************************************************************/
resource "oci_identity_policy" "connhub_loganalytics" {
  compartment_id = oci_identity_compartment.workload.id
  description    = "Allow Log Push to LogAnalytics Policy."
  name           = "allow-log-push-loganalytics-policy"
  statements = [
    ### allow service serviceconnector は無い
    format(
      ### Upload to LogAnalytics
      "allow any-user to {LOG_ANALYTICS_LOG_GROUP_UPLOAD_LOGS} in compartment %s where all {request.principal.type='serviceconnector', request.principal.compartment.id='%s', target.loganalytics-log-group.id='%s'}",
      oci_identity_compartment.workload.name,
      oci_identity_compartment.workload.id,
      oci_log_analytics_log_analytics_log_group.this.id
    ),
    format(
      ### Use to Notifications
      "allow any-user to use ons-topics in compartment %s where all {request.principal.type= 'serviceconnector', request.principal.compartment.id='%s'}",
      oci_identity_compartment.workload.name,
      oci_identity_compartment.workload.id
    )
  ]
}