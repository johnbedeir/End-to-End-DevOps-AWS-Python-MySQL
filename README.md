# End-to-end DevOps | Python - MySQL App

<img src=imgs/cover.png>

This is a simple Python Flask application that performs CRUD operations on a MySQL database, the project contains scripts and Kubernetes manifests for deploying the Python application with Mysql Database on an AWS EKS cluster and RDS with an accompanying ECR repositories. The deployment includes setting up monitoring with Prometheus and Grafana, and a CI/CD pipeline.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- [Python](https://www.python.org/downloads/)
- [MySQL For Ubuntu](https://dev.mysql.com/downloads/repo/apt/) | [MySQL For Windows](https://dev.mysql.com/downloads/installer/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with appropriate permissions
- [Docker](https://docs.docker.com/engine/install/) installed and configured
- [kubectl](https://kubernetes.io/docs/tasks/tools/) installed and configured to interact with your Kubernetes cluster
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Helm](https://helm.sh/docs/intro/install/)
- [GitHub_CLI](https://github.com/cli/cli)
- [K9s](https://k9scli.io/topics/install/)
- [Beekeeper-Studio](https://www.beekeeperstudio.io/) `For Database Access`

## 1. Running the Application Locally

### Setting Up the Database

1. Start your MySQL server.
2. Create a new MySQL database for the application.
3. Update the database configuration in `app.py` to match your local MySQL settings:

   - DB_HOST: localhost
   - DB_USER: your MySQL username
   - DB_PASSWORD: your MySQL password
   - DB_DATABASE: your database name

4. Create a table in the database that will be used by your application
   ```
   CREATE TABLE tasks (
   id SERIAL PRIMARY KEY,
   title VARCHAR(255) NOT NULL,
   description TEXT,
   is_complete BOOLEAN DEFAULT false
   );
   ```

### Running the App

1. Clone the repository:

   ```
   git clone https://github.com/johnbedeir/End-to-end-DevOps-Python-MySQL
   cd End-to-end-DevOps-Python-MySQL/todo-app
   ```

2. Create a virtual environment and activate it:

   ```
   python3 -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. Install the required dependencies:

   ```
   pip3 install -r requirements.txt
   ```

4. Start the Flask application:

   ```
   python3 app.py
   ```

5. Access the application at `http://localhost:5000`.

## 2. Running with Docker (Optional)

1. Build the Docker image:

   ```
   docker build -t my-flask-app .
   ```

2. Run the Docker container with host network (to access the local MySQL server):

   ```
   docker run --network=host my-flask-app
   ```

3. Access the application at `http://localhost:5000`.

## 3. Running App and Database with Docker compose (Optional)

To run the application using docker compose:

```
docker-compose up
```

This will Run both the application and the database containers and will also create a table in the database using the sql script `init-db.sql`

To take it down run the following command:

```
docker-compose down
```

## 4. Build, Deploy and Run the application on AWS EKS and RDS

To build and deploy the application on AWS EKS and RDS execute the following script:

```
./build.sh
```

This will build the infrastructure, Deploy Monitoring Tools, and run some commands:

1.  EKS (Kubernetes Cluster)
2.  2x ECR (Elastic Container Registry) `One for the App Image and one for the DB K8s Job`
3.  RDS (Relational Database Service) `RDS Cluster with One Instance`
4.  Generate and store RDS credentials into AWS Secret Manager
5.  VPC, Subnets and Network Configuration
6.  Monitoring Tools Deployment (Alert Manager, Prometheus, Grafana)
7.  Build and Push the Dockerfile for the Application and MySQL Kubernetes Job to the ECR
8.  Create Kubernetes Secrets with the RDS Credentials
9.  Create Namespace and Deploy the application and the Job
10. Reveal the LoadBalancer URL for the application, alertmanager, prometheus and grafana

`IMPORTANT: Make sure to update the Variables in the script`

## 5. Access the application

Once the `build.sh` script is executed, you should see the URLs for all the deployed applications:

**NOTE: For the `alert-manager` use the port `9093` after the URL, and for `prometheus` use port `9090`.**

<img src=imgs/loadbalancer.png>

The application should look like this:

<img src=imgs/app-1.png>

And once you add data should look like this:

<img src=imgs/app-2.png>

You can `Complete` or `Delete` the task and this will take effect automatically in the database.

## 6. Access the database

### Option 1: Terminal

You will also get the database endpoint URL:

<img src=imgs/rds.png>

Use that URL and access the database using the following comand:

```
mysql -h RDS_ENDPOINT_URL -P 3306 -u root -p
```

**NOTE: Once you run the command you will be asked for the database password, you have 2 methods to get the database password:**

#### Method 1:

Open `K9s` through the terminal, `Ctrl+A` to navicate to the main screen `/secrets` to search for the k8s secrets and inside the secrets `/rds` to search for names that include `rds`, you should get the following:

<img src=imgs/secrets-1.png>

Over `rds-password` tab `x` so you can decode the encrypted password

<img src=imgs/secrets-2.png>

#### Method 2:

Through AWS, navigate to `Secret Manager` on `AWS`

<img src=imgs/aws-1.png>

Click on the created secret `rds-cluster-secret` and from the Overview tab click on `Retrieve secret value`

<img src=imgs/aws-2.png>

This will show you the username and the generated password for the database.

<img src=imgs/aws-3.png>

Once you connected to the database throug the terminal you can run the following commands to check the data into the database:

```
show databases;
use DATABASE_NAME;
show tables;
select * from TABLE_NAME;
```

<img src=imgs/db-terminal.png width=500>

### Option 2: Beekeeper Studio

Choose the database `MYSQL`, fill in the `Host`, `User`, `Password`, make sue the port is `3306` then connect.

<img src=imgs/db-connect.png>

<img src=imgs/db-connect-2.png>

<img src=imgs/db-connect-3.png>

## 7. CI/CD Workflows

This project is equipped with GitHub Actions workflows to automate the Continuous Integration (CI) and Continuous Deployment (CD) processes.

### Continuous Integration Workflow

The CI workflow is triggered on pushes to the `main` branch. It performs the following tasks:

- Checks out the code from the repository.
- Configures AWS credentials using secrets stored in the GitHub repository.
- Logs in to Amazon ECR.
- Builds the Docker image for the Python app.
- Builds the Docker image for MySQL Kubernetes job.
- Tags the images and pushes each one to the it's Amazon ECR repository.

### Continuous Deployment Workflow

The CD workflow is triggered upon the successful completion of the CI workflow. It performs the following tasks:

- Checks out the code from the repository.
- Configures AWS credentials using secrets stored in the GitHub repository.
- Sets up `kubectl` with the required Kubernetes version.
- Deploys the Kubernetes manifests found in the `k8s` directory to the EKS cluster.

### GitHub Actions Secrets:

The following secrets need to be set in your GitHub repository for the workflows to function correctly:

- `AWS_ACCESS_KEY_ID`: Your AWS Access Key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS Secret Access Key.
- `KUBECONFIG_SECRET`: Your Kubernetes config file encoded in base64.

#### 1. Setting Up GitHub Secrets for AWS

Before using the GitHub Actions workflows, you need to set up the AWS credentials as secrets in your GitHub repository. The included `github_secrets.sh` script automates the process of adding your AWS credentials to GitHub Secrets, which are then used by the workflows. To use this script:

1. Ensure you have the GitHub CLI (`gh`) installed and authenticated.
2. Run the script with the following command:

   ```bash
   ./github_secrets.sh
   ```

This script will:

- Extract your AWS Access Key ID and Secret Access Key from your local AWS configuration.
- Use the GitHub CLI to set these as secrets in your GitHub repository.

**Note**: It's crucial to handle AWS credentials securely. The provided script is for demonstration purposes, and in a production environment, you should use a secure method to inject these credentials into your CI/CD pipeline.

These secrets are consumed by the GitHub Actions workflows to access your AWS resources and manage your Kubernetes cluster.

#### 2. Adding KUBECONFIG to GitHub Secrets

For the Continuous Deployment workflow to function properly, it requires access to your Kubernetes cluster. This access is granted through the `KUBECONFIG` file. You need to add this file manually to your GitHub repository's secrets to ensure secure and proper deployment.

To add your `KUBECONFIG` to GitHub Secrets, follow these steps:

1. Encode your `KUBECONFIG` file to a base64 string:

   ```bash
   cat ~/.kube/config | base64
   ```

2. Copy the encoded output to your clipboard.

3. Navigate to your GitHub repository on the web.

4. Go to `Settings` > `Secrets` > `New repository secret`.

5. Name the secret `KUBECONFIG_SECRET`.

6. Paste the base64-encoded `KUBECONFIG` data into the secret's value field.

7. Click `Add secret` to save the new secret.

This `KUBECONFIG_SECRET` is then used by the CD workflow to authenticate with your Kubernetes cluster and apply the required configurations.

**Important**: Be cautious with your `KUBECONFIG` data as it provides administrative access to your Kubernetes cluster. Only store it in secure locations, and never expose it in logs or to unauthorized users.

## 8. Destroying the Infrastructure

In case you need to tear down the infrastructure and services that you have deployed, a script named `destroy.sh` is provided in the repository. This script will:

- Log in to Amazon ECR.
- Delete the specified Docker image from the ECR repository.
- Delete the Kubernetes deployment and associated resources.
- Delete the Kubernetes namespace.
- Destroy the AWS resources created by Terraform.

### Before you run

1. Open the `destroy.sh` script.
2. Ensure that the variables at the top of the script match your AWS and Kubernetes settings:

   ```bash
   $1="ECR_REPOSITORY_NAME"
   $2="REGION"
   ```

### How to Run the Destroy Script

1. Save the script and make it executable:

   ```bash
   chmod +x destroy.sh
   ```

2. Run the script:

   ```bash
   ./destroy.sh
   ```

This script will execute another script `ecr-img-delete.sh` which will delete all the images on the two `ECR` to make sure the both `ECR` are empty then `terraform` commands to destroy all resources related to your deployment.

Once the `terraform destroy` starts the `RDS` will start creating a `Snapshot` as a backup for the database, in that case the process of destroying will fail at some point.

The script will delete the created `Snapshot` then run `terraform destroy` again to make sure all resources are deleted.

```
aws rds delete-db-cluster-snapshot --db-cluster-snapshot-identifier $rds_snapshot_name --region $region
```

It is essential to verify that the script has completed successfully to ensure that all resources have been cleaned up and no unexpected costs are incurred.

```
Make sure to replace URLs, database configuration details, and any other specific instructions to fit your project. This README provides a basic guideline for users to set up and run your application both locally, with Docker, with Docker Compose and also over EKS and RDS.
```
