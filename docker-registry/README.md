# Docker registry

Docker registry and all necessary resources required to run it.

This module is likely to be merged into some other module some time in a future.

## Usage

Using docker registry with Yandex.

### Local usage
```commandline
cat docker-push.json \
| docker login --username json_key \
               --password-stdin \
               cr.yandex
```
`docker-push.json` is created in the Terraform folder.

### From install the compute instance
1. Make sure the instance has service account for `docker-pull` attached in Yandex Cloud.
2. Install Yandex CLI into the instance (https://cloud.yandex.ru/docs/cli/operations/install-cli#non-interactive)
3. Run the following command every time before doing `docker pull`:
```commandline
docker login --username iam \
             --password $(yc iam create-token) \
              cr.yandex
```
