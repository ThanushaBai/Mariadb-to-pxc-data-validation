#!/bin/bash
# Sets up two MySQL containers for data validation practice.

echo "Starting source and target MySQL containers..."

sudo docker run --name source-mysql \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -p 3306:3306 -d mysql:8.0

sudo docker run --name target-mysql \
  -e MYSQL_ROOT_PASSWORD=my-secret-pw \
  -p 3307:3306 -d mysql:8.0

echo "Waiting for MySQL to initialize..."
sleep 30

echo "Creating sample database on source..."
sudo docker exec source-mysql mysql -uroot -pmy-secret-pw -e "
CREATE DATABASE sample_db;
USE sample_db;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');
" 2>/dev/null

echo "Creating sample database on target (with deliberate mismatch)..."
sudo docker exec target-mysql mysql -uroot -pmy-secret-pw -e "
CREATE DATABASE sample_db;
USE sample_db;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');
" 2>/dev/null

echo "Lab setup complete."