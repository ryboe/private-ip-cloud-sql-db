#!/bin/bash
set -euo pipefail

# We write the key to /var because it's one of the few directories that A) is
# writeable, and B) persists between reboots. B is important because GCP will
# automatically reboot the server if it goes down. We don't want to lose the
# key after a reboot.
echo '${service_account_key}' >/var/svc_account_key.json
chmod 444 /var/svc_account_key.json

# TODO: delete this line and add the `--pull=always` flag to `docker run`
docker pull gcr.io/cloudsql-docker/gce-proxy:latest

# -p 127.0.0.1:5432:3306 -- cloud_sql_proxy exposes port 3306 on the container, even for Postgres.
#                           We map 3306 in the container to 5432 on the host. '127.0.0.1' means
#                           that you can only connect to host port 5432 over localhost.
# -v /var/svc_account_key.json:/key.json:ro -- The file provisioner will copy the service account key file to /key.json
#                                              on the host. We will mount it read-only into the container at the
#                                              same path.
# -ip_address_types=PRIVATE -- The proxy should only try to connect to the db's private IP.
# -instances=${db_instance_name}=tcp:0.0.0.0:3306 -- The instance name will be something like 'my-project:us-central1:my-db'.
#                                                    The proxy should accept incoming TCP connections on port 3306.
docker run --rm -p 127.0.0.1:5432:3306 -v /var/svc_account_key.json:/key.json:ro gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy -credential_file=/key.json -ip_address_types=PRIVATE -instances=${db_instance_name}=tcp:0.0.0.0:3306
