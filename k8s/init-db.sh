#!/bin/bash

# Database credentials
DB_HOST="rds-cluster.cluster-cxzadf8nmshb.eu-central-1.rds.amazonaws.com"
DB_NAME="todo_db"
DB_USER="root"
DB_PASS="password"

# SQL query
SQL_QUERY="
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  is_complete BOOLEAN DEFAULT false
);

"

# Connect to the database and execute query
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$SQL_QUERY"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Table created successfully"
else
    echo "Error occurred in table creation"
fi
