CREATE TRIGGER tr_Delete_Employee
ON [dbo].[tbl_employees]
AFTER DELETE
AS
BEGIN
    INSERT INTO [dbo].[tbl_job_history] (Employee, status, end_date)
    SELECT d.id, 'Resign', GETDATE()
    FROM deleted d;
END;
CREATE VIEW tes_view
SELECT tbl_countries_1.*, dbo.tbl_account.*, dbo.tbl_account.username AS Expr1, dbo.tbl_account.is_expired AS Expr2
FROM     dbo.tbl_countries AS tbl_countries_1 CROSS JOIN
                  dbo.tbl_account INNER JOIN
                  dbo.tbl_account_roles ON dbo.tbl_account.id = dbo.tbl_account_roles.account