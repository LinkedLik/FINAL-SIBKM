CREATE PROCEDURE department_regis
    @Departmentid int,
        @DepartmentName varchar(50),
    @Location int
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tbl_departments WHERE id = @Departmentid)
    BEGIN
        PRINT 'Department already exists.'
    END
        ELSE
        BEGIN
    INSERT INTO tbl_departments(id,name, location)
    VALUES (@Departmentid, @DepartmentName, @Location)
        END
END

CREATE VIEW vw_account_details AS(
SELECT dbo.tbl_employees.id, dbo.tbl_account.username, dbo.tbl_account.password
FROM     dbo.tbl_employees INNER JOIN
                  dbo.tbl_account ON dbo.tbl_employees.id = dbo.tbl_account.id
);

CREATE TRIGGER tr_Delete_Employee
ON [dbo].[tbl_employees]
AFTER DELETE
AS
BEGIN
    INSERT INTO [dbo].[tbl_job_history] (Employee, status, end_date)
    SELECT d.id, 'Resign', GETDATE()
    FROM deleted d;
END;

CREATE PROCEDURE sp_delete_country
    @country_id INT
AS
BEGIN
    -- Check if the country exists
    IF NOT EXISTS (SELECT 1 FROM tbl_countries WHERE id = @country_id)
    BEGIN
        RAISERROR ('Country not found', 16, 1);
        RETURN;
    END
	    DELETE FROM tbl_countries
    WHERE id = @country_id;

SELECT 'Country deleted successfully' AS message;
END

EXEC sp_delete_country @country_id = 1;



CREATE PROCEDURE sp_delete_region
    @region_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_regions WHERE id = @region_id)
    BEGIN
        RAISERROR ('Region not found', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM tbl_countries WHERE id = @region_id)
    BEGIN
        RAISERROR ('Region has associated countries, cannot delete', 16, 1);
        RETURN;
    END

    DELETE FROM tbl_regions
    WHERE id = @region_id;

    SELECT 'Region deleted successfully' AS message;
END

EXEC sp_delete_region @region_id = 1;

CREATE PROCEDURE sp_delete_roles
    @role_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_roles WHERE id = @role_id)
    BEGIN
        RAISERROR ('Role not found', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM tbl_roles WHERE id = @role_id)
    BEGIN
        RAISERROR ('Role is assigned to users, cannot delete', 16, 1);
        RETURN;
    END


    DELETE FROM tbl_roles
    WHERE id = @role_id;


    SELECT 'Role deleted successfully' AS message;
END

EXEC sp_delete_roles @role_id = 1;

CREATE PROCEDURE sp_delete_location
    @location_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_locations WHERE id = @location_id)
    BEGIN
        RAISERROR ('Location not found', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM tbl_departments WHERE location = @location_id)
    BEGIN
        RAISERROR ('Location has associated assets, cannot delete', 16, 1);
        RETURN;
    END


    DELETE FROM tbl_locations
    WHERE id = @location_id;

    SELECT 'Location deleted successfully' AS message;
END

EXEC sp_delete_location @location_id = 1;

CREATE PROCEDURE sp_delete_department
    @department_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_departments WHERE id = @department_id)
    BEGIN
        RAISERROR ('Department not found', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM tbl_employees WHERE id = @department_id)
    BEGIN
        RAISERROR ('Department has associated employees, cannot delete', 16, 1);
        RETURN;
    END


    DELETE FROM tbl_departments
    WHERE id = @department_id;


    SELECT 'Department deleted successfully' AS message;
END
EXEC sp_delete_department @department_id = 1;

CREATE PROCEDURE sp_delete_job
    @job_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_jobs WHERE id = @job_id)
    BEGIN
        RAISERROR ('Job not found', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM tbl_job_history WHERE job = @job_id)
    BEGIN
        RAISERROR ('Job has associated job steps, cannot delete', 16, 1);
        RETURN;
    END


    DELETE FROM tbl_jobs
    WHERE id = @job_id;


    SELECT 'Job deleted successfully' AS message;
END
EXEC sp_delete_job @job_id = 1;

CREATE PROCEDURE sp_delete_employee
    @employee_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_employees WHERE id = @employee_id)
    BEGIN
        RAISERROR ('Employee not found', 16, 1);
        RETURN;
    END


    IF EXISTS (SELECT 1 FROM tbl_job_history WHERE employee = @employee_id)
    OR EXISTS (SELECT 1 FROM tbl_jobs WHERE id = @employee_id)
    BEGIN
        RAISERROR ('Employee has associated data in other tables, cannot delete', 16, 1);
        RETURN;
    END


    DELETE FROM tbl_employees
    WHERE id = @employee_id;


    SELECT 'Employee deleted successfully' AS message;
END

EXEC sp_delete_employee @employee_id = 1;

CREATE PROCEDURE sp_delete_role_permission
    @role_id INT,
    @permission_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_roles WHERE id = @role_id)
    BEGIN
        RAISERROR ('Role not found', 16, 1);
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM tbl_role_permissions WHERE permission = @permission_id)
    BEGIN
        RAISERROR ('Permission not found', 16, 1);
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM tbl_role_permissions WHERE id = @role_id AND permission = @permission_id)
    BEGIN
        RAISERROR ('Role permission not found', 16, 1);
        RETURN;
    END


    DELETE FROM tbl_role_permissions
    WHERE id = @role_id AND permission = @permission_id;


    SELECT 'Role permission deleted successfully' AS message;
END
EXEC sp_delete_role_permission @role_id, @permission_id = 1;

CREATE PROCEDURE sp_update_permission
    @permission_id INT,
    @permission_role NVARCHAR(50),
    @permission_description NVARCHAR(200)
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM tbl_role_permissions WHERE id = @permission_id)
    BEGIN
        RAISERROR ('Permission not found', 16, 1);
        RETURN;
    END


    UPDATE tbl_role_permissions
    SET role = @permission_role,
        permission = @permission_description
    WHERE id = @permission_id;


    SELECT 'Permission updated successfully' AS message;
END

EXEC sp_update_permission @permission_id = 1, @permission_role = '', @permission_description = '';

CREATE PROCEDURE sp_update_employee
    @employee_id INT,
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @email VARCHAR(100),
    @phone VARCHAR(20),
    @job_title VARCHAR(50),
    @department_id INT,
    @manager_id INT,
	@gender VARCHAR(20),
	@hire_date VARCHAR(30),
	@salary INT
AS
BEGIN
    UPDATE tbl_employees
    SET 
        first_name = @first_name,
        last_name = @last_name,
		gender = @gender,
        Email = @email,
        Phone = @phone,
		hire_date = @hire_date,
		salary = @salary,
        Job = @job_title,
        Department = @department_id,
        Manager = @manager_id
    WHERE id = @employee_id;

    IF @@ROWCOUNT = 0
        RAISERROR ('Employee not found', 16, 1);

    RETURN 0;
END

EXEC sp_update_employee 
	@employee_id = '',
	@first_name = '' ,
	@last_name = '',
	@email = '',
	@phone = '' ,
	@job_title = '',
	@department_id = '',
	@manager_id = '',
	@gender = '',
	@hire_date = '',
	@salary = '';


