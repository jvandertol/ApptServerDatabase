CREATE PROCEDURE [dbo].[Users_Get]
    @Id bigint 
AS
BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from

	SET NOCOUNT ON;

		select 
			u.UserId Id
			,u.FirstName
			,u.LastName
			,u.Address
			,u.Address2
			,u.City
			,u.Region
			,u.PoCode
			,u.CreatedAt
			,u.UserName
			,u.NormalizedUserName
			,u.Email
			,u.NormalizedEmail
			,u.EmailConfirmed
			,u.PasswordHash
			,u.SecurityStamp
			,u.ConcurrencyStamp
			,u.PhoneNumber
			,u.PhoneNumberConfirmed
			,u.TwoFactorEnabled
			,u.LockoutEnd
			,u.LockoutEnabled
			,u.AccessFailedCount
			,u.IsDeleted		
			,cua.Companyid 
		from users	u 
			join security.CompanyUserAssoc cua on u.UserId = cua.UserId	
		WHERE u.UserId = @Id;
  
  select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'users'

		select @@ROWCOUNT 


END TRY
BEGIN CATCH
 DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    -- Get the error details
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Rollback the transaction if it's still open
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
    END

    -- Log the error or raise it
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH