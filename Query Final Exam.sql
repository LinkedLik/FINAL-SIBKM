CREATE DATABASE Employee_Management
GO

USE Employee_Management
GO

CREATE TABLE tbl_job_history(
employee INT PRIMARY KEY,
start_date DATE NOT NULL,
end_date DATE,
status VARCHAR(10) NOT NULL,
job VARCHAR(10) NOT NULL,
department INT NOT NULL
);

CREATE TABLE tbl_departments(
id INT PRIMARY KEY IDENTITY(1001,1),
name VARCHAR(25) NOT NULL,
location INT NOT NULL,
);

CREATE TABLE tbl_employees(
id INT PRIMARY KEY IDENTITY(100000,1),
first_name VARCHAR(25) NOT NULL,
last_name VARCHAR(25),
gender VARCHAR(10) NOT NULL,
email VARCHAR(25) UNIQUE NOT NULL,
phone VARCHAR(20),
hire_date DATE NOT NULL,
salary INT,
manager INT,
job VARCHAR(10) NOT NULL,
department INT NOT NULL
);

CREATE TABLE tbl_jobs(
id VARCHAR(10) PRIMARY KEY,
title VARCHAR(35) NOT NULL,
min_salary INT,
max_salary INT
);

CREATE TABLE tbl_locations(
id INT PRIMARY KEY IDENTITY (1001,1),
street_address VARCHAR(40),
postal_code VARCHAR(12),
city VARCHAR(3) NOT NULL,
state_province VARCHAR(25),
country CHAR(3) NOT NULL
);

CREATE TABLE tbl_account(
id INT PRIMARY KEY,
username VARCHAR(25),
password VARCHAR(255),
otp INT NOT NULL,
is_expired BIT NOT NULL,
is_used DATETIME NOT NULL
);

CREATE TABLE tbl_permissions(
id INT PRIMARY KEY IDENTITY (1001,1),
name VARCHAR(100) NOT NULL
);

CREATE TABLE tbl_countries(
id CHAR(3) PRIMARY KEY,
name VARCHAR(40) NOT NULL,
region INT NOT NULL
);

CREATE TABLE tbl_regions(
id INT PRIMARY KEY IDENTITY (1,1),
name VARCHAR(25) NOT NULL
);

CREATE TABLE tbl_roles(
id INT PRIMARY KEY IDENTITY (1001,1),
name VARCHAR(50) NOT NULL
);

CREATE TABLE tbl_role_permissions(
id INT PRIMARY KEY IDENTITY (1001,1),
role INT NOT NULL,
permission INT NOT NULL
);

CREATE TABLE tbl_account_roles(
id INT PRIMARY KEY IDENTITY(1001,1),
account INT NOT NULL,
role INT NOT NULL
);