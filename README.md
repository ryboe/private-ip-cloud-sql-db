# Cloud SQL DB with a Private IP

This repo demonstrates how to create a Cloud SQL DB with a private IP address
only, and connect to it with [Cloud SQL Proxy](https://cloud.google.com/sql/docs/postgres/sql-proxy). The full explanation of how this works can be found in [this blog post](https://medium.com/@ryanboehning/how-to-deploy-a-cloud-sql-db-with-a-private-ip-only-using-terraform-e184b08eca64).

## Deploy the db and Cloud SQL Proxy

```bash
gcloud services enable \
    cloudresourcemanager.googleapis.com \
    compute.googleapis.com \
    iam.googleapis.com \
    oslogin.googleapis.com \
    servicenetworking.googleapis.com \
    sqladmin.googleapis.com

terraform init
terraform apply
```

## Upload your public SSH key to Google's OS Login service

```bash
gcloud compute os-login ssh-keys add --key-file=~/.ssh/id_rsa.pub --ttl=365d
```

## Connect to the private db through Cloud SQL Proxy

```bash
# get your SSH username
gcloud compute os-login describe-profile | grep username

# psql into your private db
ssh -t <username>@<proxy-ip-address> docker run --rm --network=host -it postgres:11-alpine psql -U postgres -h localhost
```
