# Todo List Python App

This is a simple Flask application that performs CRUD operations on a MySQL database.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed Python 3.
- You have installed MySQL.
- You have a MySQL server running locally.
- You have Docker installed (optional for containerized setup).

## Running the Application Locally

### Setting Up the Database

1. Start your MySQL server.
2. Create a new MySQL database for the application.
3. Update the database configuration in `app.py` to match your local MySQL settings:

   - DB_HOST: localhost
   - DB_USER: your MySQL username
   - DB_PASSWORD: your MySQL password
   - DB_DATABASE: your database name

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

## Running with Docker (Optional)

1. Build the Docker image:

   ```
   docker build -t my-flask-app .
   ```

2. Run the Docker container with host network (to access the local MySQL server):

   ```
   docker run --network=host my-flask-app
   ```

3. Access the application at `http://localhost:5000`.

## Running App and Database with Dockercompose (Optional)

## Contributing

Contributions to this project are welcome. Please follow the standard process of forking the repository and submitting a pull request.

## License

Include license information here, if applicable.

```

Make sure to replace URLs, database configuration details, and any other specific instructions to fit your project. This README provides a basic guideline for users to set up and run your application both locally and with Docker.
```
