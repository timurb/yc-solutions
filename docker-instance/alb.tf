resource "yandex_alb_target_group" "default" {
  name = var.app_name
  target {
    subnet_id = local.instance_subnet
    ip_address = yandex_compute_instance.docker-instance.network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "application" {
  name = var.app_name

  http_backend {
    name = var.app_name
    port = 80
    weight = 1
    target_group_ids = [yandex_alb_target_group.default.id]
  }
}

resource "yandex_alb_backend_group" "dashboards" {
  name = "${var.app_name}-dashboards"

  http_backend {
    name = "${var.app_name}-dashboards"
    port = 8090
    weight = 1
    target_group_ids = [yandex_alb_target_group.default.id]
  }
}

resource "yandex_alb_http_router" "application" {
  name = var.app_name
}

resource "yandex_alb_http_router" "dashboards" {
  name = "${var.app_name}-dashboards"
}

resource "yandex_alb_virtual_host" "application" {
  name = var.app_name

  http_router_id = yandex_alb_http_router.application.id

  route {
    name = var.app_name
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.application.id
      }
    }
  }
}

resource "yandex_alb_virtual_host" "dashboards" {
  name = "${var.app_name}-dashboards"

  http_router_id = yandex_alb_http_router.dashboards.id

  route {
    name = "${var.app_name}-dashboards"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.dashboards.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "default" {
  name = var.app_name
  network_id = data.terraform_remote_state.networking.outputs.network

  allocation_policy {
    location {  ###FIXME use several networks
      zone_id   = data.terraform_remote_state.networking.outputs.zones[0]
      subnet_id = data.terraform_remote_state.networking.outputs.subnets_public[0]
    }
  }

  listener {
    name = "http"

    endpoint {
      address {
        external_ipv4_address {
          address = data.terraform_remote_state.networking.outputs.application_ip
        }
      }
      ports = [ 80 ]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.application.id
      }
    }
  }

  listener {
    name = "system"

    endpoint {
      address {
        external_ipv4_address {
          address = data.terraform_remote_state.networking.outputs.application_ip
        }
      }
      ports = [ 8090 ]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.dashboards.id
      }
    }
  }
}
