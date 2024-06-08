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
city VARCHAR(30) NOT NULL,
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

ALTER TABLE tbl_employees ADD CONSTRAINT FK_tbl_employees_tbl_departments FOREIGN KEY(department)
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

ALTER TABLE tbl_role_permissions ADD CONSTRAINT FK_tbl_role_permissions_tbl_permissions FOREIGN KEY(permission)
REFERENCES tbl_permissions (id);

ALTER TABLE tbl_role_permissions ADD CONSTRAINT FK_tbl_role_permissions_tbl_roles FOREIGN KEY(role)
REFERENCES tbl_roles (id);

ALTER TABLE tbl_employees ADD CONSTRAINT cek_gender CHECK(gender IN ('MALE','FEMALE'));

ALTER TABLE tbl_employees ADD CONSTRAINT gender_check CHECK(dbo.func_gender(gender) = 1);

ALTER TABLE tbl_employees ADD CONSTRAINT check_email CHECK(dbo.func_email_format(email) = 1);

ALTER TABLE tbl_account ADD CONSTRAINT check_password CHECK(dbo.func_password_policy(password) = 1);

CREATE PROCEDURE usp_login @user VARCHAR(25), @password VARCHAR(255)
AS
SELECT username, password
FROM tbl_account
WHERE username = @user AND password = @password;

EXEC usp_login @user = 'admin', @password = 'password';

CREATE PROCEDURE usp_register @id INT, @namadepan VARCHAR(25), 
@namabelakang VARCHAR(25), @jeniskelamin VARCHAR(10), @email VARCHAR(25),
@phone VARCHAR(25), @tanggalgabung DATE, @gaji INT, @managjer INT, 
@kerjaan VARCHAR(10), @department INT
AS
BEGIN
IF EXISTS (SELECT 1 FROM tbl_employees WHERE id = @id)
BEGIN
PRINT'Employee Already Exist'
END
ELSE
BEGIN
INSERT INTO tbl_employees VALUES(@namadepan, @namabelakang, @jeniskelamin, @email, @phone, @tanggalgabung, @gaji, @managjer, @kerjaan, @department);
END
END

DROP PROCEDURE usp_register;

EXEC usp_register @namadepan = 'joe', @namabelakang = 'doe', @jeniskelamin = 'male', @email = 'joed@test.com', @phone = '654846512454', @tanggalgabung = '20-MAR-2021', @gaji = 2000, @managjer = '', @kerjaan = 'IT', @department = 1;

CREATE PROCEDURE job_regis @jobsid VARCHAR(10), @jobname VARCHAR(35), @minsal INT, @maxsal INT
AS
BEGIN
IF EXISTS (SELECT 1 FROM tbl_employees WHERE id = @jobsid)
BEGIN 
PRINT ('Jobs Already Exist')
END
ELSE
BEGIN
INSERT INTO tbl_jobs VALUES (@jobsid, @jobname, @minsal, @maxsal)
END
END

CREATE VIEW vw_employee_details AS (
SELECT tbl_employees.id, CONCAT(tbl_employees.first_name, ' ', tbl_employees.last_name) AS full_name, tbl_employees.gender, tbl_employees.email, tbl_employees.phone, tbl_employees.hire_date, tbl_job_histories.status, 
                  tbl_employees.salary, tbl_employees.manager, CONCAT(tbl_employees.first_name, ' ', tbl_employees.last_name) AS manager_name, tbl_locations.city, tbl_roles.name, tbl_departments.name AS department, 
                  tbl_account.username
FROM     tbl_employees INNER JOIN
                  tbl_departments ON tbl_employees.id = tbl_departments.id INNER JOIN
                  tbl_roles ON tbl_employees.id = tbl_roles.id INNER JOIN
                  tbl_locations ON tbl_departments.location = tbl_locations.id INNER JOIN
                  tbl_job_histories ON tbl_employees.id = tbl_job_histories.employee AND tbl_departments.id = tbl_job_histories.department INNER JOIN
                  tbl_account ON tbl_employees.id = tbl_account.id
WHERE tbl_employees.id <> tbl_employees.manager
AND tbl_employees.first_name = tbl_employees.manager
);

SELECT * FROM vw_employee_details;

CREATE PROCEDURE loc_regis @id INT, @jalan VARCHAR(40), 
@kodepos VARCHAR(12), @kota VARCHAR(30), @provinsi VARCHAR(25), @negara CHAR(3)
AS
BEGIN
IF EXISTS (SELECT 1 FROM tbl_locations WHERE id = @id)
BEGIN
PRINT 'Location already exist'
END
ELSE
BEGIN
INSERT INTO tbl_locations VALUES (@jalan, @kodepos, @kota, @provinsi, @negara)
END
END

EXEC loc_regis @id = 1001, @jalan = 'tanjung duren', @kodepos = '11400', @kota = 'jakarta barat', @provinsi = 'jakarta', @negara = 'IND';

CREATE PROCEDURE country_regis @id CHAR(3), @negara VARCHAR(40), @wilayah INT
AS
BEGIN
IF EXISTS (SELECT 1 FROM tbl_countries WHERE id = @id)
BEGIN 
PRINT 'Country already exist'
END
ELSE
BEGIN
INSERT INTO tbl_countries VALUES (@id, @negara, @wilayah)
END
END

CREATE PROCEDURE region_regis @id INT, @region VARCHAR(25)
AS
BEGIN
IF EXISTS (SELECT 1 FROM tbl_regions WHERE id = @id)
BEGIN
PRINT 'Region already exist'
END
ELSE
BEGIN
INSERT INTO tbl_regions VALUES (@region)
END
END

CREATE FUNCTION func_email_format(
	@email VARCHAR(25)
) RETURNS BIT AS
BEGIN
DECLARE @emailtext VARCHAR(25)
DECLARE @emailval AS BIT
SET @emailtext =  LTRIM(RTRIM(ISNULL(@email,'')))
SET @emailval = CASE WHEN @emailtext = '' THEN 0
					WHEN @emailtext LIKE '% %' THEN 0
					WHEN @emailtext LIKE ('%[]"(),;:<>\]%') THEN 0
					WHEN SUBSTRING(@emailtext,CHARINDEX('@',@emailtext),LEN(@emailtext)) LIKE ('%[]!#$%&^*()[]{}\|;:"=-+-%/?><.,') THEN 0
					WHEN (LEFT(@emailtext,1) LIKE ('[-_.+]') OR RIGHT(@emailtext,1) LIKE ('[-_.+]')) THEN 0
					WHEN @emailtext LIKE '%[%' OR @emailtext like'%]%' THEN 0
					WHEN @emailtext LIKE '%@%@%' THEN 0
					WHEN @emailtext NOT LIKE '_%@_%._%' THEN 0
					ELSE 
					1
				END
		RETURN @emailval
	END

CREATE FUNCTION func_password_policy(
@password VARCHAR(255)
)
RETURNS INT
BEGIN
DECLARE @validate INT
IF LEN(@password) >8 AND PATINDEX('%[0-9]%',@password) > 0 AND PATINDEX('%[a-zA-Z]%', @password) > 0
SET @validate = 1
ELSE
SET @validate = 0
RETURN @validate
END

CREATE FUNCTION func_gender(
@gender VARCHAR(10)
)
RETURNS INT
BEGIN
DECLARE @validate INT
SET @validate = CASE WHEN @gender = 'MALE' THEN 1
					WHEN @gender = 'Male' THEN 1
					WHEN @gender = 'male' THEN 1
					WHEN @gender = 'FEMALE' THEN 1
					WHEN @gender = 'Female' THEN 1
					WHEN @gender = 'female' THEN 1
			ELSE
			0
		END
		RETURN @validate
	END


CREATE TRIGGER tr_insert_employee 
ON tbl_employees
AFTER INSERT
AS
BEGIN
INSERT INTO tbl_job_histories(employee, start_date, status, job, department)
SELECT ID, getdate(), 'Active', job, department FROM INSERTED;
END

CREATE TRIGGER tr_update_employee_job
ON tbl_employees
AFTER UPDATE
AS
BEGIN
UPDATE tbl_job_histories
SET status = 'Hand Over'
FROM tbl_job_histories
INNER JOIN INSERTED i ON tbl_job_histories.employee = i.id
END

/* Over Engineered
CREATE FUNCTION func_otp_generate(
@otp INT
)
RETURNS INT
AS 
BEGIN
DECLARE @digit INT;
DECLARE @hash BIGINT = CONVERT(BIGINT, HASHBYTES('SHA2_256', CONVERT(VARBINARY, @otp)));
WHILE LEN(@digit) < 6
BEGIN
SET @digit = @digit + CONVERT(VARCHAR, (@hash & 0xF));
SET @hash = @hash >> 4;
END
RETURN @digit;
END;


CREATE FUNCTION func_otp_generate()
RETURNS INT
AS
BEGIN
    DECLARE @otp INT;
    EXEC sp_executesql N'SET @otp = FLOOR(RAND() * 900000) + 100000;', N'@otp INT OUTPUT', @otp OUTPUT;
    RETURN @otp;
END;

*/

CREATE FUNCTION dbo.func_otp_generate(@seed INT)
RETURNS INT
AS
BEGIN
    DECLARE @otp INT;
    SET @otp = FLOOR(ABS(CHECKSUM(@seed)) % 900000) + 100000;
    RETURN @otp;
END;

DECLARE @seed INT = DATEPART(ms, GETDATE());
SELECT dbo.func_otp_generate(@seed) AS OTP;

DROP FUNCTION dbo.func_otp_generate;

SELECT * FROM tbl_account;

CREATE PROCEDURE usp_generate_otp
@email VARCHAR(25),
@otp INT,
@generate INT OUTPUT,
@input INT
AS
BEGIN
IF EXISTS (SELECT 1 FROM tbl_employees WHERE email = @email)
BEGIN
EXEC @generate = dbo.func_otp_generate @input;
UPDATE
END
ELSE
BEGIN
PRINT'Email tidak ditemukan'
END
END
