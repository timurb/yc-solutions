resource "yandex_container_registry" "default" {
  name      = var.registry_name
}

resource "yandex_iam_service_account" "push" {
  name = "docker-push"
  description = "Service account for docker pushes from Github CI builds"
}

resource "yandex_iam_service_account" "pull" {
  name = "docker-pull"
  description = "Service account for docker pulls"
}

resource "yandex_resourcemanager_folder_iam_member" "push" {
  folder_id = data.terraform_remote_state.landing-zone.outputs.folder_id
  role               = "container-registry.images.pusher"
  member             = "serviceAccount:${yandex_iam_service_account.push.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "pull" {
  folder_id = data.terraform_remote_state.landing-zone.outputs.folder_id
  role               = "container-registry.images.puller"
  member             = "serviceAccount:${yandex_iam_service_account.pull.id}"
}
resource "yandex_iam_service_account_key" "push" {
  service_account_id = yandex_iam_service_account.push.id
  description        = "API key for docker pushes"
}

resource "yandex_iam_service_account_key" "pull" {
  service_account_id = yandex_iam_service_account.pull.id
  description        = "API key for docker pulls"
}

resource "local_file" "push_key" {
  filename = "docker-push.json"
  content = jsonencode(yandex_iam_service_account_key.push)
}

resource "local_file" "pull_key" {
  filename = "docker-pull.json"
  content = jsonencode(yandex_iam_service_account_key.pull)
}
