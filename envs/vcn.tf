/************************************************************
VCN
************************************************************/
resource "oci_core_vcn" "vcn" {
  compartment_id = oci_identity_compartment.workload.id
  cidr_block     = "10.0.0.0/16"
  display_name   = "vcn"
  # 最大15文字の英数字
  # 文字から始めること
  # ハイフンとアンダースコアは使用不可
  # 後から変更不可
  dns_label    = "vcn"
  defined_tags = local.common_defined_tags
}

/************************************************************
Security List
************************************************************/
##### For FLB
resource "oci_core_security_list" "sl_flb" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "sl-flb"
  defined_tags   = local.common_defined_tags
}

##### For System
resource "oci_core_security_list" "sl_system" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "sl-system"
  defined_tags   = local.common_defined_tags
}

##### For Bastion
resource "oci_core_security_list" "sl_bastion" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "sl-bastion"
  defined_tags   = local.common_defined_tags
  # セッションを張る際は、Bastion Private Endpoint が送信元となる
  # Bastion Private Endpoint がターゲットリソースと同一サブネットでも、許可する必要がある点注意
  # Bastion Private Endpoint は NSG で制御できないので、SL での制御が必要
  egress_security_rules {
    protocol         = "6"
    description      = "Connect to SSH"
    destination      = "10.0.2.0/24"
    stateless        = false
    destination_type = "CIDR_BLOCK"
    tcp_options {
      min = 22
      max = 22
    }
  }
}

/************************************************************
Subnet
************************************************************/
### For FLB
resource "oci_core_subnet" "public_flb" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  cidr_block     = "10.0.1.0/24"
  display_name   = "public-flb"
  # 最大15文字の英数字
  # 文字から始めること
  # ハイフンとアンダースコアは使用不可
  # 後から変更不可
  dns_label         = "flbnw"
  security_list_ids = [oci_core_security_list.sl_flb.id]
  # prohibit_internet_ingress と prohibit_public_ip_on_vnic は 同様の動き
  # そのため、２つのパラメータの true/false を互い違いにするとconflictでエラーとなる
  # 基本的には、値を揃えるか、どちらか一方を明記すること
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
  defined_tags               = local.common_defined_tags
}

### For System
resource "oci_core_subnet" "private_system" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  cidr_block     = "10.0.2.0/24"
  display_name   = "private-system"
  # 最大15文字の英数字
  # 文字から始めること
  # ハイフンとアンダースコアは使用不可
  # 後から変更不可
  dns_label         = "systemnw"
  security_list_ids = [oci_core_security_list.sl_system.id]
  # prohibit_internet_ingress と prohibit_public_ip_on_vnic は 同様の動き
  # そのため、２つのパラメータの true/false を互い違いにするとconflictでエラーとなる
  # 基本的には、値を揃えるか、どちらか一方を明記すること
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  defined_tags               = local.common_defined_tags
}

### For Bastion
resource "oci_core_subnet" "private_bastion" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  cidr_block     = "10.0.3.0/24"
  display_name   = "private-bastion"
  # 最大15文字の英数字
  # 文字から始めること
  # ハイフンとアンダースコアは使用不可
  # 後から変更不可
  dns_label         = "bastionnw"
  security_list_ids = [oci_core_security_list.sl_bastion.id]
  # prohibit_internet_ingress と prohibit_public_ip_on_vnic は 同様の動き
  # そのため、２つのパラメータの true/false を互い違いにするとconflictでエラーとなる
  # 基本的には、値を揃えるか、どちらか一方を明記すること
  prohibit_internet_ingress  = true
  prohibit_public_ip_on_vnic = true
  defined_tags               = local.common_defined_tags
}

/************************************************************
Internet Gateway
************************************************************/
resource "oci_core_internet_gateway" "igw" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "igw"
  defined_tags   = local.common_defined_tags
}

/************************************************************
NAT Gateway
************************************************************/
resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "nat-gateway"
  defined_tags   = local.common_defined_tags
}

/************************************************************
Route Table
************************************************************/
### For FLB
resource "oci_core_route_table" "rtb_flb" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "rtb-flb"
  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  defined_tags = local.common_defined_tags
}

resource "oci_core_route_table_attachment" "attachment_flb" {
  subnet_id      = oci_core_subnet.public_flb.id
  route_table_id = oci_core_route_table.rtb_flb.id
}

### For System
resource "oci_core_route_table" "rtb_system" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "rtb-system"
  route_rules {
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
  defined_tags = local.common_defined_tags
}

resource "oci_core_route_table_attachment" "attachment_system" {
  subnet_id      = oci_core_subnet.private_system.id
  route_table_id = oci_core_route_table.rtb_system.id
}

### For Bastion
resource "oci_core_route_table" "rtb_bastion" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "rtb-bastion"
  defined_tags   = local.common_defined_tags
}

resource "oci_core_route_table_attachment" "attachment_bastion" {
  subnet_id      = oci_core_subnet.private_bastion.id
  route_table_id = oci_core_route_table.rtb_bastion.id
}

/************************************************************
Network Security Group
************************************************************/
### For FLB
resource "oci_core_network_security_group" "sg_flb" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "sg-flb"
  defined_tags   = local.common_defined_tags
}

resource "oci_core_network_security_group_security_rule" "sg_flb_ingress_http" {
  network_security_group_id = oci_core_network_security_group.sg_flb.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = var.source_ip
  stateless                 = false
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "sg_flb_egress_http" {
  network_security_group_id = oci_core_network_security_group.sg_flb.id
  protocol                  = "6"
  direction                 = "EGRESS"
  destination               = oci_core_network_security_group.sg_oracle.id
  stateless                 = false
  destination_type          = "NETWORK_SECURITY_GROUP"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

### For Oracle Linux
resource "oci_core_network_security_group" "sg_oracle" {
  compartment_id = oci_identity_compartment.workload.id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "sg-oracle"
  defined_tags   = local.common_defined_tags
}

resource "oci_core_network_security_group_security_rule" "sg_oracle_ingress_ssh" {
  network_security_group_id = oci_core_network_security_group.sg_oracle.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "10.0.3.0/24"
  stateless                 = false
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "sg_oracle_ingress_http" {
  network_security_group_id = oci_core_network_security_group.sg_oracle.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = oci_core_network_security_group.sg_flb.id
  stateless                 = false
  source_type               = "NETWORK_SECURITY_GROUP"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "sg_oracle_egress_all" {
  network_security_group_id = oci_core_network_security_group.sg_oracle.id
  protocol                  = "all"
  direction                 = "EGRESS"
  destination               = "0.0.0.0/0"
  stateless                 = false
  destination_type          = "CIDR_BLOCK"
}