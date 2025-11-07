CREATE PROCEDURE [dbo].[RefreshTokens_Set]
    @UserId bigint 
    ,@RefreshToken varchar(max) 
    ,@IssuedAt datetime2(3) 
    ,@ExpiresAt DateTime2(3)
    ,@IsRevoked bit = null
    ,@RevokedAt DateTime2(3)
AS
BEGIN TRY

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE RefreshTokens
			SET
				RefreshToken = CASE 
								WHEN @RefreshToken IS NOT NULL THEN @RefreshToken 
								ELSE RefreshToken 
							   END,
				IssuedAt = GETUTCDATE(),
				ExpiresAt = DATEADD(M,1,getutcdate()),
				IsRevoked = CASE 
							WHEN @IsRevoked IS NOT NULL THEN @IsRevoked 
							ELSE IsRevoked 
						   END,
				RevokedAt = CASE 
							WHEN @RevokedAt IS NOT NULL THEN @RevokedAt 
							ELSE RevokedAt 
						   END
		WHERE UserId = @UserId;
  
	if (@@ROWCOUNT = 0 ) begin

		insert into RefreshTokens
		select 
			@UserId			
			,@RefreshToken		
			,GETUTCDATE()		
			,DATEADD(M,1,getutcdate())		
			,@IsRevoked			
			,@RevokedAt			
		
		select @UserId
	end

	select @UserId

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