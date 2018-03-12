##################################################################################
# VARIABLES
##################################################################################
#Global Variables
variable "vcenter_address" {}
variable "vcenter_user" {}
variable "vcenter_password" {}
variable "vsphere_dc" {}

#DB Variables
variable "db_cpu" {}
variable "db_mem" {}
variable "os_template" {}
variable "vm_datastore" {}
variable "vm_network" {}
variable "vsphere_clus" {}

##################################################################################
# PROVIDERS
#################################################################################

provider "vsphere" {
  vsphere_server = "${var.vcenter_address}"
  user = "${var.vcenter_user}"
  password = "${var.vcenter_password}"
  allow_unverified_ssl = "True"
}

##################################################################################
# Data Source
##################################################################################

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_dc}"
}

data "vsphere_datastore" "datastore" {
  name = "${var.vm_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name = "${var.vm_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name = "${var.os_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name = "${var.vsphere_clus}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

