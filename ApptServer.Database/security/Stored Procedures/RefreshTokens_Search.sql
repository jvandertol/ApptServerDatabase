CREATE PROCEDURE [security].[RefreshTokens_Search]
    @RefreshToken VARCHAR(256)
AS
BEGIN TRY

	--exec security.RefreshTokens_Search 'gU0vigiv+yxaF+HEVVZHSofSRVRSLNCLJGzUk8v0XlZ+7lB3gum6W5DuSeO9jm6ts6apt8ow5A09p9SjwOZubw=='
	--select * from security.RefreshTokens where RefreshToken = 'gU0vigiv+yxaF+HEVVZHSofSRVRSLNCLJGzUk8v0XlZ+7lB3gum6W5DuSeO9jm6ts6apt8ow5A09p9SjwOZubw=='
	--select @RefreshToken;

	SET NOCOUNT ON;

	declare @PageNumber int = 0,
    @PageId bigint = 1, 
    @Forward bit = 1,
    @PageSize int =20,
    @MaxPages int =3

	--select @Forward = isnull(@Forward,1)

	CREATE TABLE #tmpC (
		[UserId] [bigint]  NOT NULL,
		[RefreshToken] [varchar](256) NOT NULL,
		[IssuedAt] DATETIME2(3) not null,
		[ExpiresAt] DATETIME2(3)  not null,
		[IsRevoked] BIT NOT NULL,
		[RevokedAt] DATETIME2(3) NULL
	)
    insert into #tmpC
		select 
			*
			from security.RefreshTokens
			where 
			RefreshToken = @RefreshToken
				and isnull(IsRevoked,0) <> 1;

	WITH NumberedRows AS (
			SELECT 
			*
			,ROW_NUMBER() OVER (ORDER BY UserId) AS RowNum
			FROM 
				#tmpC
		)
		SELECT 
			(ROW_NUMBER() OVER (ORDER BY (RowNum - 1) / @PageSize) - 1) / 1 + 1 + @PageNumber AS PageNumber,  -- Calculate page number with @PageNumber
			MIN(UserId) AS FirstId,                                                                -- Return the minimum CompanyId for that page
			MAX(UserId) AS LastId
		FROM 
			NumberedRows
		GROUP BY 
			(RowNum - 1) / @PageSize                                                                         -- Group by calculated page number
		ORDER BY 
			PageNumber;                                                                                       -- Order by page number

	-- Result set 2
	SELECT 
	[UserId] Id
	,[RefreshToken]
	,[IssuedAt]
	,[ExpiresAt]
	,[IsRevoked]
	,[RevokedAt]
	FROM #tmpC;

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