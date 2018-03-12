##################################################################################
# DB RESOURCES
##################################################################################

resource "vsphere_folder" "dbfolder" {
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
  type = "vm"
  path = "DB Tier"
}

resource "vsphere_virtual_machine" "dbserver" {
  name = "postgresdbserver"
  folder = "${vsphere_folder.dbfolder.path}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"

  num_cpus = 2
  memory = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label = "disk0"
    size = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "postgresdb"
        domain = "localhost.localdomain"
      }
      network_interface {
        ipv4_address = "172.20.10.6"
        ipv4_netmask = 28
      }

      ipv4_gateway = "172.20.10.1"
      dns_server_list = ["172.20.10.1"]
    }
  }
  provisioner "remote-exec" {
    connection {
      user = "root"
      password = "password"
    }
    inline = [
      "docker run --name postgres-petclinic -e POSTGRES_PASSWORD=petclinic -e POSTGRES_DB=petclinic -p 5432:5432 -d postgres:9.6.0",
      "docker ps"
    ]
  }
}
