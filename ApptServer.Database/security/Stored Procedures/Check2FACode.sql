CREATE PROCEDURE [security].[Check2FACode]
@TwoFACode int 
,@AuthContactValue varchar(50)
,@AuthContactMethodId smallint
,@origin varchar(250)
,@ResultCode smallint OUTPUT 

/*
-- user found no jwt
select * from security.twofactorcode

-- found
declare @ResultCode BIT
exec [security].[Check2FACode] '654322','123@boo.com', 2,'https://localhost:5176', @ResultCode output
select @ResultCode

-- not found companyid wrong 
declare @ResultCode BIT
exec [security].[Check2FACode] '654322','123@boo.com', 2,'https://localhost:5177', @ResultCode output
select @ResultCode

-- not found authcode wrong 
declare @ResultCode bit
exec [security].[Check2FACode] '654321','123@boo.com', 2,'https://localhost:5176', @ResultCode output
select @ResultCode

-- not found authvalue wrong 
declare @ResultCode bit
exec [security].[Check2FACode] '654322','123x@boo.com', 2,'https://localhost:5176', @ResultCode output
select @ResultCode


select * from users
*/

AS BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @CompanyId bigint --get from origin
	select @ResultCode = -2

	-- get company from origin
	select @CompanyId = a.CompanyId from security.AllowedURLs a where a.Url = @origin

	-- if no row found then @ResultCode remains 0, otherwise @ResultCode set by case statement
	SELECT @ResultCode = case when UserId is not null then 2 else 3 end FROM security.TwoFactorCode t where t.AuthCode = @TwoFACode and t.CompanyId = @CompanyId and t.AuthContactValue = @AuthContactValue and t.AuthContactMethodId = @AuthContactMethodId 

END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorNumber INT;

    -- Capture the error message and error number
    SET @ErrorMessage = ERROR_MESSAGE();
    SET @ErrorNumber = ERROR_NUMBER();

    -- You can log it or re-throw the error
    PRINT 'Error Number: ' + CAST(@ErrorNumber AS NVARCHAR(10));
    PRINT 'Error Message: ' + @ErrorMessage;

    -- Optionally, you can re-throw the error if needed
    THROW;  --

END CATCH