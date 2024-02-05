#!/bin/bash

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
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_DATABASE" -e "$SQL_QUERY"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Table created successfully"
else
    echo "Error occurred in table creation"
fi
