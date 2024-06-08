CREATE FUNCTION func_otp_match (@otp NVARCHAR(6), @storedOtp NVARCHAR(6))
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT;

    IF (@otp = @storedOtp)
        SET @result = 1;
    ELSE
        SET @result = 0;

    RETURN @result;
END;

