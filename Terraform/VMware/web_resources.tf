##################################################################################
# WEB RESOURCES
##################################################################################

resource "vsphere_folder" "webfolder" {
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
  type = "vm"
  path = "Web Tier"
}

resource "vsphere_virtual_machine" "webserver" {
  name = "webserver"
  folder = "${vsphere_folder.webfolder.path}"
  datastore_id = "${data.vsphere_datastore.datastore.id}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"

  num_cpus = 1
  memory = 756
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
        host_name = "webserver"
        domain = "localhost.localdomain"
      }
      network_interface {
        ipv4_address = "172.20.10.9"
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
      "cd /app/web_server",
      "docker build . -t web_server_container",
      "docker run -d -p 80:80 web_server_container"
    ]
  }
  depends_on = ["vsphere_virtual_machine.appserver"]
}
