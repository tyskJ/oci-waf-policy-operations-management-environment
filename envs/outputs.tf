/************************************************************
SSH port forwarding
************************************************************/
# output "ssh_port_forwarding_oracle" {
#   value = <<-EOT
#     ssh -v -i ./.key/private_bastion.pem \
#     -N -L 22222:${oci_bastion_session.ssh_port_forwarding_oracle.target_resource_details[0].target_resource_private_ip_address}:22 \
#     -p 22 ${oci_bastion_session.ssh_port_forwarding_oracle.id}@host.bastion.${local.region_map["NRT"]}.oci.oraclecloud.com
#   EOT
# }

# output "ssh_command_after_ssh_port_forwarding_oracle" {
#   value = <<-EOT
#     ssh -i ./.key/private_oracle.pem \
#     -p 22222 opc@localhost
#   EOT
# }

/************************************************************
Web URL
************************************************************/
output "web_url" {
  value = <<-EOT
    http://${oci_core_public_ip.flb.ip_address}/
  EOT
}

output "xss_request" {
  # value = "http://${oci_core_public_ip.flb.ip_address}/?<pstyle="background:url(javascript:alert(1))">"
  value = <<-EOT
    http://${oci_core_public_ip.flb.ip_address}/?&lt;pstyle="background:url(javascript:alert(1))"&gt;
  EOT
}

output "sqli_request" {
  # value = "http://${oci_core_public_ip.flb.ip_address}/?id=1′ UNION SELECT NULL,username,password FROM users"
  value = <<-EOT
    http://${oci_core_public_ip.flb.ip_address}/?id=1%27%20UNION%20SELECT%20NULL,username,password%20FROM%20users
  EOT
}