# data Blocks
data "openstack_networking_network_v2" "kube_public_network" {
  name = "kube-public"
}

data "openstack_networking_network_v2" "kube_private_network" {
  name = "kube-private"
}

# Security Groups
resource "openstack_networking_secgroup_v2" "sg1" {
  name        = "security-group-1"
  description = "Allow SSH, HTTP, HTTPS traffic and TCP traffic from kube-public network"
}

resource "openstack_networking_secgroup_rule_v2" "sg1_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg1.id
}

resource "openstack_networking_secgroup_rule_v2" "sg1_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg1.id
}

resource "openstack_networking_secgroup_rule_v2" "sg1_rule_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg1.id
}
resource "openstack_networking_secgroup_rule_v2" "sg1_rule_tcp_kube_public" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.sg1.id
}
resource "openstack_networking_secgroup_v2" "sg2" {
  name        = "security-group-2"
  description = "Allow TCP and UDP traffic from kube-public and kube-private networks"
}

resource "openstack_networking_secgroup_rule_v2" "sg2_rule_tcp_kube_public" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "192.168.1.0/24"
  security_group_id = openstack_networking_secgroup_v2.sg2.id
}

resource "openstack_networking_secgroup_rule_v2" "sg2_rule_tcp_kube_private" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "192.168.2.0/24"
  security_group_id = openstack_networking_secgroup_v2.sg2.id
}

resource "openstack_networking_secgroup_rule_v2" "sg2_rule_udp_kube_private" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = "192.168.2.0/24"
  security_group_id = openstack_networking_secgroup_v2.sg2.id
}

# Virtual Machines
resource "openstack_compute_instance_v2" "rancher_server" {
  count       = 1
  name        = "rancher-server"
  flavor_name = "standard.medium"
  image_name  = "Ubuntu-20.04"
  key_pair    = "cloud"
  security_groups = [openstack_networking_secgroup_v2.sg1.name]
  network {
    uuid = data.openstack_networking_network_v2.kube_public_network.id
  }
}

resource "openstack_compute_instance_v2" "kube_master" {
  count       = 1
  name        = "kube-master"
  flavor_name = "standard.medium"
  image_name  = "Ubuntu-20.04"
  key_pair    = "cloud"
  security_groups = [openstack_networking_secgroup_v2.sg2.name]
  network {
    uuid = data.openstack_networking_network_v2.kube_public_network.id
  }
  network {
    uuid = data.openstack_networking_network_v2.kube_private_network.id
  }
}

resource "openstack_compute_instance_v2" "kube_worker_a" {
  count       = 1
  name        = "kube-worker-a"
  flavor_name = "standard.tiny"
  image_name  = "Ubuntu-20.04"
  key_pair    = "cloud"
  security_groups = [openstack_networking_secgroup_v2.sg2.name]
  network {
    uuid = data.openstack_networking_network_v2.kube_public_network.id
  }
  network {
    uuid = data.openstack_networking_network_v2.kube_private_network.id
  }
}

resource "openstack_compute_instance_v2" "load_balancer" {
  count       = 1
  name        = "load-balancer"
  flavor_name = "standard.tiny"
  image_name  = "Ubuntu-20.04"
  key_pair    = "cloud"
  security_groups = [openstack_networking_secgroup_v2.sg1.name]
  network {
    uuid = data.openstack_networking_network_v2.kube_public_network.id
  }
}

# Floating IPs and Associations
resource "openstack_networking_floatingip_v2" "rancher_server_fip" {
  pool = "public"
}

resource "openstack_networking_floatingip_v2" "load_balancer_fip" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "rancher_server_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.rancher_server_fip.address
  instance_id = openstack_compute_instance_v2.rancher_server[0].id
}

resource "openstack_compute_floatingip_associate_v2" "load_balancer_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.load_balancer_fip.address
  instance_id = openstack_compute_instance_v2.load_balancer[0].id
}
