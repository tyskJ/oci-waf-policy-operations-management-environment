/************************************************************
Network Address Lists
************************************************************/
### CIDR
resource "oci_waf_network_address_list" "this" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "white-list"
  type           = "ADDRESSES" # or VCN_ADDRESSES
  addresses = [
    var.source_ip
  ]
  defined_tags = local.common_defined_tags
}

# /************************************************************
# Regional WAF Policy
# ************************************************************/
# resource "oci_waf_web_app_firewall_policy" "this" {
#   compartment_id = oci_identity_compartment.workload.id
#   display_name   = "regional-waf-policy"
#   #### Actions
#   ### Default
#   actions {
#     code = 0
#     name = "Pre-configured Check Action"
#     type = "CHECK"
#   }
#   ### Default
#   actions {
#     code = 0
#     name = "Pre-configured Allow Action"
#     type = "ALLOW"
#   }
#   ### Default
#   actions {
#     code = 401
#     name = "Pre-configured 401 Response Code Action"
#     type = "RETURN_HTTP_RESPONSE"
#     body {
#       template = null
#       text = jsonencode({
#         code    = "401"
#         message = "Unauthorized"
#       })
#       type = "STATIC_TEXT"
#     }
#     headers {
#       name  = "Content-Type"
#       value = "application/json"
#     }
#   }
#   ### Custom
#   actions {
#     code = 403
#     name = "Custom-configured-403-response-code-action"
#     type = "RETURN_HTTP_RESPONSE"
#     body {
#       template = jsonencode({
#         code      = "403"
#         message   = "Forbidden"
#         RequestId = "$${http.request.id}"
#       })
#       text = null
#       type = "DYNAMIC"
#     }
#   }
#   ### Custom
#   actions {
#     code = 429
#     name = "Custom-configured-429-response-code-action"
#     type = "RETURN_HTTP_RESPONSE"
#     body {
#       template = jsonencode({
#         code      = "429"
#         message   = "Too Many Requests"
#         RequestId = "$${http.request.id}"
#       })
#       text = null
#       type = "DYNAMIC"
#     }
#   }
#   #### Access control
#   ### Request access rules
#   request_access_control {
#     ### rulesの記載順序=評価順
#     ### 上から評価さる
#     ###　→　マッチしなければ次のルールを評価
#     ###　→　マッチしたら評価終了
#     ###　→　全てのルールにマッチしなければdefault_action
#     rules {
#       type               = "ACCESS_CONTROL"
#       name               = "restrict-source-ip"
#       condition_language = "JMESPATH"
#       condition          = "!address_in_network_address_list(connection.source.address, ['${oci_waf_network_address_list.this.id}'])"
#       action_name        = "Pre-configured 401 Response Code Action"
#     }
#     rules {
#       type               = "ACCESS_CONTROL"
#       name               = "restrict-country-jp"
#       condition_language = "JMESPATH"
#       condition          = "!i_contains(['JP'], connection.source.geo.countryCode)"
#       action_name        = "Pre-configured 401 Response Code Action"
#     }
#     default_action_name = "Pre-configured Allow Action" # "Pre-configured Allow Action" or "Pre-configured 401 Response Code Action" or Custom
#   }
#   ### Response access rules
#   # response_access_control {
#   # }
#   #### Rate limiting
#   request_rate_limiting {
#     ### rulesの記載順序=評価順
#     ### 上から評価さる
#     ### Conditionはオプション。指定しない場合は全リクエスト対象
#     rules {
#       type               = "REQUEST_RATE_LIMITING"
#       name               = "rate-limit"
#       condition_language = "JMESPATH"
#       configurations {
#         requests_limit             = 1
#         period_in_seconds          = 1
#         action_duration_in_seconds = 0
#       }
#       action_name = "Custom-configured-429-response-code-action"
#     }
#   }
#   #### Protections
#   request_protection {
#     body_inspection_size_limit_in_bytes = 8192
#     rules {
#       action_name                = "Custom-configured-403-response-code-action"
#       condition_language         = "JMESPATH"
#       is_body_inspection_enabled = false
#       name                       = "recommend-rules"
#       type                       = "PROTECTION"
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "942270"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "942260"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9420000"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9420000"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "941140"
#         version                        = 3
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9410000"
#         version                        = 3
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9410000"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9410000"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9330000"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9330000"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9320001"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9320001"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9320000"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9320000"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "930120"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9300000"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "9300000"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "920390"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "920380"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "920370"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "920320"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "920300"
#         version                        = 2
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "920300"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "920280"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "911100"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "200003"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "200002"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "200001"
#         version                        = 1
#       }
#       protection_capabilities {
#         collaborative_action_threshold = 0
#         key                            = "200000"
#         version                        = 1
#       }
#     }
#   }
#   defined_tags = local.common_defined_tags
# }

# /************************************************************
# Regional WAF - FLB Attached
# ************************************************************/
# resource "oci_waf_web_app_firewall" "this" {
#   compartment_id             = oci_identity_compartment.workload.id
#   display_name               = "flb-waf"
#   backend_type               = "LOAD_BALANCER"
#   load_balancer_id           = oci_load_balancer_load_balancer.flb.id
#   web_app_firewall_policy_id = oci_waf_web_app_firewall_policy.this.id
#   defined_tags               = local.common_defined_tags
# }