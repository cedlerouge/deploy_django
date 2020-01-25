resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_security_group" "www" {
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  for (i=0; i < length(var.ssh_allowed_ip); i++) {
  inbound_rule {
    action = "accept"
    port   = "22"
    ip     = var.ssh_allowed_ip[i]
  }
  }

  inbound_rule {
    action = "accept"
    port   = "80"
  }

  inbound_rule {
    action = "accept"
    port   = "443"
  }
}

resource "scaleway_instance_server" "betwit" {
  type  = "DEV1-S"
  image = "ubuntu-bionic"

  tags  = [ "django", "betwit" ]

  root_volume {
    delete_on_termination = true
  }

  ip_id              = scaleway_instance_ip.public_ip.id
  enable_dynamic_ip  = false

  security_group_id  = scaleway_instance_security_group.www.id

  cloud_init         = file("${path.module}/cloud_init.yml")
}

output "public_ip" {
  value = scaleway_instance_ip.public_ip
}
