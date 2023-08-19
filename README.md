<!-- BEGIN_TF_DOCS -->


# Terraform Module for Amazon RDS for PostgreSQL and MySQL 

Terraform module for automating deployment of Amazon RDS PostgreSQL & MySQL databases with Multi-AZ DB Cluster and also related resources following AWS best practices.

## High level architecture of Multi-AZ DB Cluster
![Amazon RDS Multi-AZ Deployment Option With Two Readable Standby Instances](https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2022/02/15/dbblog-1927-image001.png)


## Supported Features

- Multi-AZ DB Cluster
- Multi-AZ DB Instance

## Module Layout
```
.
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── modules
│   └── rds_modules
│       ├── rds_db_cluster
│       │   ├── README.md
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── variables.tf
│       │   └── versions.tf
│       ├── rds_db_instance
│       │   ├── README.md
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── variables.tf
│       │   └── versions.tf
│       ├── rds_db_option_group
│       │   ├── README.md
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── variables.tf
│       │   └── versions.tf
│       ├── rds_db_parameter_group
│       │   ├── README.md
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── variables.tf
│       │   └── versions.tf
│       ├── rds_db_subnet_group
│       │   ├── README.md
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── variables.tf
│       │   └── versions.tf
│       └── rds_vpc
│           ├── main.tf
│           ├── outputs.tf
│           └── variables.tf
├── rds_multiaz_cluster
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── versions.tf
├── rds_multiaz_instance
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── versions.tf
└── rds_multiaz_to_multiaz_cluster
    ├── main.tf
    ├── outputs.tf
    ├── variables.tf
    └── versions.tf
```

## Deployment Procedure

To deploy the Terraform Amazon RDS module, do the following:

1. Install Terraform. For instructions and a video tutorial, see [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).

2. Sign up and log into [Terraform Cloud](https://www.terraform.io/cloud) (There is a free tier available).
   1.  Create a [Terraform organization](https://www.terraform.io/docs/cloud/users-teams-organizations/organizations.html#creating-organizations).

3. Configure [Terraform Cloud API access](https://learn.hashicorp.com/tutorials/terraform/cloud-login). Run the following to generate a Terraform Cloud token from the command line interface:
   ```
   terraform login

   --For Mac/Linux
   export TERRAFORM_CONFIG="$HOME/.terraform.d/credentials.tfrc.json"

   --For Windows
   export TERRAFORM_CONFIG="$HOME/AppData/Roaming/terraform.d/credentials.tfrc.json"
   ```

4. [Install](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) the AWS Command Line Interface (AWS CLI).

5. If you don't have git installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

6. Clone this **aws-samples/multi-az-db-cluster-sample-for-amazon-rds** repository using the following command:

   `git clone https://github.com/aws-samples/multi-az-db-cluster-sample-for-amazon-rds`

7. Change directory to the root repository directory.

   `cd multi-az-db-cluster-sample-for-amazon-rds/`

8. Workflow for new deployment

    Let’s get started by pulling the GitHub Terraform modules for deploying the Multi-AZ DB cluster.

    1. Create a VPC and deploy the Terraform RDS Multi-AZ DB cluster module by running the following commands in your terminal window:
        ```
        Cd <TF_DIR>/ multi-az-db-cluster-sample-for-amazon-rds/rds_multiaz_cluster/
        terraform init
        ```

    2. Once initialized, update the variables.tf file with the following to deploy either PostgreSQL or MySQL.
        ```
        var.database_name
        var.engine [Either postgres or mysql]
        var.kms_key_id
        var.name
        var.rds_secret_name
        ````

    3. Save the changes of variables.tf
        ```
        terraform apply
        ```

9. Workflow for existing deployment: A Snapshot of a Multi-AZ DB Cluster

    In this example, we create a new Multi-AZ DB cluster from an existing snapshot of a Multi-AZ DB cluster. Complete the following steps:

    1. Create a VPC and deploy the Terraform RDS Multi-AZ DB cluster using the existing snapshot by running the following commands in your terminal window:
        ```
        Cd <TF_DIR>/ multi-az-db-cluster-sample-for-amazon-rds/rds_multiaz_to_multi-az_cluster /
        terraform init
        ```
    2. Once initialized, update the variables.tf file with the following to deploy either PostgreSQL or MySQL using snapshot identifier.
        ```
        var.database_name
        var.kms_key_id
        var.name
        var.rds_secret_name
        var.snapshot_db_cluster_identifier
        ```
    3. Save the changes of variables.tf.
        ```
        terraform apply
        ```

10. Clean Up

      Some of the AWS resources created by the Terraform RDS Multi-AZ instance and cluster modules incur costs as long as they are in use. When you no longer need the resources, clean them up by deleting the Multi-AZ cluster with the VPCs as follows. Run the following commands in your terminal window:
        ```  
        cd <TF_DIR>/multi-az-db-cluster-sample-for-amazon-rds/rds_multiaz_to_multi-az_cluster/
        terraform destroy  
        ```
        
## Authors
   
Sharath Chandra Kampili (kampilis@amazon.com), Sudhir Admin (sudhamin@amazon.com)

