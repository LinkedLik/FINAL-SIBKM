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

