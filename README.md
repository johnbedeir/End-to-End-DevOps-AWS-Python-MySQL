# Todo List Python App

This is a simple Flask application that performs CRUD operations on a MySQL database.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed Python 3.
- You have installed MySQL.
- You have a MySQL server running locally.
- You have Docker installed.

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

### Running the Flask App

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
2.  ECR (Elastic Container Registry)
3.  RDS (Relational Database Service)
4.  VPC, Subnets and Network Configuration
5.  Monitoring Tools Deployment (Alert Manager, Prometheus, Grafana)
6.  Build and Push the Dockerfile for the Application and MySQL Kubernetes Job to the ECR
7.  Create Kubernetes Secrets with the RDS Credentials
8.  Create Namespace and Deploy the application
9.  Reveal the LoadBalancer URL for the application, alertmanager, prometheus and grafana

`IMPORTANT: Make sure to update the Variables in the script`

## Contributing

Contributions to this project are welcome. Please follow the standard process of forking the repository and submitting a pull request.

## License

Include license information here, if applicable.

```

Make sure to replace URLs, database configuration details, and any other specific instructions to fit your project. This README provides a basic guideline for users to set up and run your application both locally and with Docker.
```
