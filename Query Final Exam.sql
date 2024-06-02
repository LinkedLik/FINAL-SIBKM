CREATE DATABASE Employee_Management
GO

USE Employee_Management
GO

CREATE TABLE tbl_job_histories(
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

ALTER TABLE tbl_account ADD CONSTRAINT FK_tbl_account_tbl_employees FOREIGN KEY(id)
REFERENCES tbl_employees (id);

ALTER TABLE tbl_account_roles ADD CONSTRAINT FK_tbl_account_roles_tbl_account FOREIGN KEY(account)
REFERENCES tbl_account (id);

ALTER TABLE tbl_account_roles ADD CONSTRAINT FK_tbl_account_roles_tbl_roles FOREIGN KEY(role)
REFERENCES tbl_roles (id);

ALTER TABLE tbl_countries ADD CONSTRAINT FK_tbl_countries_tbl_regions FOREIGN KEY(region)
REFERENCES tbl_regions (id);

ALTER TABLE tbl_departments ADD CONSTRAINT FK_tbl_departments_tbl_locations FOREIGN KEY(location)
REFERENCES tbl_locations (id);

ALTER TABLE tbl_employees ADD CONSTRAINT FK_tbl_employees_tbl_departments FOREIGN KEY(id)
REFERENCES tbl_departments (id);

ALTER TABLE tbl_employees ADD CONSTRAINT FK_tbl_employees_tbl_employees FOREIGN KEY(manager)
REFERENCES tbl_employees (id);

ALTER TABLE tbl_employees ADD CONSTRAINT FK_tbl_employees_tbl_jobs FOREIGN KEY(job)
REFERENCES tbl_jobs (id);

ALTER TABLE tbl_job_histories ADD CONSTRAINT FK_tbl_job_histories_tbl_departments FOREIGN KEY(department)
REFERENCES tbl_departments (id);

ALTER TABLE tbl_job_histories ADD CONSTRAINT FK_tbl_job_histories_tbl_employees FOREIGN KEY(employee)
REFERENCES tbl_employees (id);

ALTER TABLE tbl_job_histories ADD CONSTRAINT FK_tbl_job_histories_tbl_jobs FOREIGN KEY(job)
REFERENCES tbl_jobs (id);

ALTER TABLE tbl_locations ADD CONSTRAINT FK_tbl_locations_tbl_countries FOREIGN KEY(country)
REFERENCES tbl_countries (id);