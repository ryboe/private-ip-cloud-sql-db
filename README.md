# Cloud SQL DB with a Private IP

This repo demonstrates how to create a Cloud SQL DB with a private IP address
only, and connect to it with [Cloud SQL Proxy](https://cloud.google.com/sql/docs/postgres/sql-proxy). The full explanation of how this works can be found in [this blog post](https://medium.com/@ryanboehning/how-to-deploy-a-cloud-sql-db-with-a-private-ip-only-using-terraform-e184b08eca64).

Terraform v0.15.0 or higher is required.

## How To Use

1. Set the name of your Terraform Cloud organization in `backend.tf`.

2. Deploy the db and Cloud SQL Proxy

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

3. Upload your public SSH key to Google's OS Login service

    ```bash
    gcloud compute os-login ssh-keys add --key-file=~/.ssh/id_rsa.pub --ttl=365d
    ```

4. Connect to the private db through Cloud SQL Proxy

    ```bash
    # get your SSH username
    gcloud compute os-login describe-profile | grep username

    # get the public IP of the instance running Cloud SQL Proxy
    CLOUD_SQL_PROXY_IP=$(terraform output proxy_ip)

    # psql into your private db
    ssh -t <username>@$CLOUD_SQL_PROXY_IP docker run --rm --network=host -it postgres:13-alpine psql -U postgres -h localhost
    ```
