/************************************************************
Container Repository
************************************************************/
resource "oci_artifacts_container_repository" "purge" {
  compartment_id = oci_identity_compartment.workload.id
  display_name   = "${var.repo_prefix}/${var.fn_name}"
  is_immutable   = false
  is_public      = false
  # readme {}
}