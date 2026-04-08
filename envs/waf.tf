/************************************************************
Regional WAF Policy
************************************************************/
resource "oci_waf_web_app_firewall_policy" "this" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "regional-waf-policy"
  actions {
    code = 0
    name = "Pre-configured Check Action"
    type = "CHECK"
  }
  actions {
    code = 0
    name = "Pre-configured Allow Action"
    type = "ALLOW"
  }
  actions {
    code = 401
    name = "Pre-configured 401 Response Code Action"
    type = "RETURN_HTTP_RESPONSE"
    body {
      template = null
      text = jsonencode({
        code    = "401"
        message = "Unauthorized"
      })
      type = "STATIC_TEXT"
    }
    headers {
      name  = "Content-Type"
      value = "application/json"
    }
  }
  request_access_control {
    default_action_name = "Pre-configured Allow Action"
  }
  defined_tags = local.common_defined_tags
}

/************************************************************
Regional WAF - FLB Attached
************************************************************/
resource "oci_waf_web_app_firewall" "this" {
  compartment_id             = oci_identity_compartment.workload.id
  display_name               = "flb-waf"
  backend_type               = "LOAD_BALANCER"
  load_balancer_id           = oci_load_balancer_load_balancer.flb.id
  web_app_firewall_policy_id = oci_waf_web_app_firewall_policy.this.id
  defined_tags               = local.common_defined_tags
}