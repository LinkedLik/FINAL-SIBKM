CREATE FUNCTION dbo.func_password_match(
    @new_password VARCHAR(225), 
    @confirm_password VARCHAR(225)
)
RETURNS INT
AS
BEGIN
    DECLARE @validate INT
    DECLARE @policy_check INT

    SET @policy_check = dbo.func_password_policy(@new_password)
    IF @policy_check = 1
        IF @new_password = @confirm_password
            SET @validate = 1
        ELSE 
            SET @validate = 0
    ELSE
        SET @validate = 0
    RETURN @validate
END


CREATE FUNCTION dbo.func_phone_number(
@phone_number VARCHAR(20))
RETURNS INT
AS
BEGIN 
	DECLARE @validate INT
	IF @phone_number NOT LIKE '%[^0-9]%' AND LEN(@phone_number) BETWEEN 10 AND 13
		SET @validate = 1
	ELSE
		SET @validate = 0

RETURN @validate
END

ALTER TABLE tbl_employee ADD CONSTRAINT check_phone_number CHECK(dbo.func_phone_number(phone)= 1)


CREATE FUNCTION dbo.func_salary(
	@job_id VARCHAR(10),
	@salary int)
RETURNS INT
AS
BEGIN
	DECLARE @validate INT
	DECLARE @min_salary INT
	DECLARE @max_salary INT
	SELECT @min_salary = min_salary , @max_salary = max_salary
	FROM tbl_jobs
	WHERE @job_id = id
	IF @salary < @min_salary OR @salary >@max_salary
		SET @validate = 0  
	ELSE
		SET @validate = 1
RETURN @validate
END
GO


CREATE PROCEDURE region_regis
   @RegionID int, @RegionName varchar(25)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tbl_regions WHERE id = @Regionid)
    BEGIN
        PRINT 'Region already exists.'
    END
    ELSE
    BEGIN
        INSERT INTO tbl_regions (name)
        VALUES (@RegionName)
    END
END


CREATE PROCEDURE dbo.sp_update_password
    @username VARCHAR(50),
	@old_password VARCHAR(225),
    @new_password VARCHAR(225),
    @confirm_password VARCHAR(225)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tbl_account WHERE username = @username)
    BEGIN
        RAISERROR ('Username does not exist', 16, 1)
        RETURN
    END
	DECLARE @current_password VARCHAR(225)
    SELECT @current_password = password FROM tbl_account WHERE username = @username
	IF @current_password <> @old_password
    BEGIN
        RAISERROR ('Password is incorrect', 16, 1)
        RETURN
    END
    IF dbo.func_password_match(@new_password, @confirm_password) = 0
    BEGIN
        RAISERROR ('New password does not meet policy or does not match', 16, 1)
        RETURN
    END

    UPDATE tbl_account
    SET password = @new_password
    WHERE username = @username
END
GO


CREATE PROCEDURE sp_update_jobs(
	@job_id VARCHAR(10),
	@title VARCHAR(30),
	@min INT,
	@max INT)
AS
BEGIN
	UPDATE tbl_jobs
	SET title = @title,
		min_salary = @min,
		max_salary = @max
	WHERE id = @job_id;
END

CREATE PROCEDURE sp_department_update(
	@dept_id INT,
	@title VARCHAR(30),
	@location int)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tbl_locations WHERE id = @location)
		BEGIN
			RAISERROR('Location is incorrect!',16,1);
			RETURN;
	END
	UPDATE tbl_departments
	SET name = @title,
		location = @location
	WHERE id = @dept_id
END


CREATE PROCEDURE sp_location_update(
	@Loc_ID INT,
	@StreetAddress VARCHAR(40),
	@PostalCode VARCHAR(12),
	@City VARCHAR(30),
	@StateProvince VARCHAR(25),
	@Country CHAR(3))
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tbl_countries WHERE id = @Country)
		BEGIN
			RAISERROR('Incorrect Country ID!',16,1);
			RETURN;
		END
		UPDATE tbl_locations
		SET street_address = @StreetAddress,
			postal_code = @PostalCode,
			city = @City,
			state_province = @StateProvince,
			country = @Country
		WHERE id = @Loc_ID
END

CREATE PROCEDURE sp_country_update(
	@CountryId CHAR(3),
	@Name VARCHAR(40),
	@RegionId INT)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tbl_regions WHERE id = @RegionId)
		BEGIN
			RAISERROR('Incorrect Region ID!',16,1);
			RETURN;
		END
		UPDATE tbl_countries
		SET name = @Name,
			region = @RegionId
		WHERE id = @CountryId
END


CREATE PROCEDURE sp_region_update(
	@RegionId INT,
	@RegionName VARCHAR(25))
AS
BEGIN
	UPDATE tbl_regions
	SET name = @RegionName
	WHERE id = @RegionId
END


CREATE PROCEDURE sp_add_role(
    @RoleID INT,
    @Name VARCHAR(50))
AS
BEGIN
	IF EXISTS (SELECT 1 FROM tbl_roles WHERE id = @RoleID)
		BEGIN
		PRINT'Role Already Exist'
		END
	ELSE
		BEGIN
		INSERT INTO tbl_roles
		VALUES (@Name)
	END
END


CREATE PROCEDURE sp_role_update(
	@RoleID INT,
	@Name VARCHAR(50))
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM tbl_roles WHERE id = @RoleID)
	BEGIN
		RAISERROR('Incorrect Role ID!',16,1);
	END
UPDATE tbl_roles
	SET name = @Name
	WHERE id = @RoleID
END


CREATE PROCEDURE sp_generate_otp
    @email nvarchar(50)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.tbl_employees WHERE email = @email)
    BEGIN
        RAISERROR ('Email does not exist', 16, 1)
        RETURN;
    END

    DECLARE @otp int
    DECLARE @seed INT = DATEPART(ms, GETDATE());
    SET @otp = dbo.func_otp_generate(@seed)

    UPDATE a
    SET a.otp = @otp, a.is_expired = 0, a.is_used = DATEADD(MINUTE, 10, GETDATE())
    FROM dbo.tbl_account a
    INNER JOIN dbo.tbl_employees e ON a.id = e.id
    WHERE e.email = @email

    --SET @new_otp = @otp
    --SET @expired_time = DATEADD(MINUTE, 10, GETDATE())
	SELECT @otp AS OTP
END


CREATE VIEW AccountRoles AS
SELECT dbo.tbl_account.id AS [Account ID], dbo.tbl_roles.name AS Role, dbo.tbl_permissions.name AS Permissions
FROM     dbo.tbl_account INNER JOIN
                  dbo.tbl_roles ON dbo.tbl_account.id = dbo.tbl_roles.id INNER JOIN
                  dbo.tbl_permissions ON dbo.tbl_account.id = dbo.tbl_permissions.id