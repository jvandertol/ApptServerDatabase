CREATE PROCEDURE [dbo].[Companies_Set]
	@CompanyId bigint null
	,@CompanyName varchar(100)
	,@Street1 varchar(200)
	,@Street2 varchar(25)
	,@City varchar(200)
	,@RegionCd varchar(2)
	,@PoCode varchar(10)
	,@PrimaryPhone varchar(15)
	,@PrimaryEmail varchar(100)
	,@UseDST bit = 1
	,@TimeZone varchar(50) = 'Pacific Standard Time'
	,@ApptPolicy varchar(3000) = ''
	,@Url varchar(150) 
	,@IsDeleted bit null = 0

	/*
	,CreatedById
	,UTCCreateDtTm
	,UpdatedById
	,UTCUpdateDtTm
	 from dbo.companies
	where CompanyId = @Id
	*/
AS
BEGIN TRY

	declare @updated bit = 0

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@CompanyId is null) begin
		-- Insert statements for procedure here
		insert into Companies values (
			@CompanyName 
			,@Street1
			,@Street2
			,@City
			,@RegionCd
			,@PoCode
			,@PrimaryPhone
			,@PrimaryEmail
			,@ApptPolicy 
			,@UseDST
			,@TimeZone
			,@IsDeleted
			,GETUTCDATE()
			,NULL
		)

		select SCOPE_IDENTITY()
	end
	else begin
    -- Insert statements for procedure here
		update Companies set
			CompanyName = case when @CompanyName is null then CompanyName else @CompanyName end
			,Street1 = case when @Street1 is null then Street1 else @Street1 end
			,Street2 = case when @Street2 is null then Street2 else @Street2 end
			,City = case when @City is null then City else @City end
			,RegionCd = case when @RegionCd is null then RegionCd else @RegionCd end
			,PoCode = case when @PoCode is null then PoCode else @PoCode end
			,PrimaryPhone = case when @PrimaryPhone is null then PrimaryPhone else @PrimaryPhone end
			,PrimaryEmail = case when @PrimaryEmail is null then PrimaryEmail else @PrimaryEmail end
			,ApptPolicy = case when @ApptPolicy is null then ApptPolicy else @ApptPolicy end
			,UseDST = isnull(@UseDST,UseDst)
			,TimeZone = isnull(@TimeZone,TimeZone)
			,UTCUpdateDtTm = GETUTCDATE()
		where CompanyId = @CompanyId

		select @@ROWCOUNT 

	end

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