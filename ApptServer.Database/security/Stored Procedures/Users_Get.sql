CREATE PROCEDURE [security].[Users_Get]
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
			,cua.UserName
			,cua.Email
			,cua.EmailConfirmed
			,cua.PasswordHash
			,cua.PhoneNumber
			,cua.PhoneNumberConfirmed
			,cua.TwoFactorEnabled
			,cua.LockoutEnd
			,cua.LockoutEnabled
			,cua.AccessFailedCount
			,cua.IsDeleted		
			,cua.Companyid 
		from security.users	u 
			join security.CompanyUserAssoc cua on u.UserId = cua.UserId	
		WHERE cua.CompanyUserAssocId = @Id;
  
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