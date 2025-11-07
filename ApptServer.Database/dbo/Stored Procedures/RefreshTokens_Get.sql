CREATE PROCEDURE [dbo].[RefreshTokens_Get]
    @Id bigint 
AS
BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from

	SET NOCOUNT ON;

		select * from RefreshTokens	WHERE UserId = @Id;
  
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