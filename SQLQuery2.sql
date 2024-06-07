CREATE TRIGGER tr_Delete_Employee
ON [dbo].[tbl_employees]
AFTER DELETE
AS
BEGIN
    INSERT INTO [dbo].[tbl_job_history] (Employee, status, end_date)
    SELECT d.id, 'Resign', GETDATE()
    FROM deleted d;
END;