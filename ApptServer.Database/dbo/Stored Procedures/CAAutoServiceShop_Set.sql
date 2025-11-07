CREATE PROCEDURE [dbo].[CAAutoServiceShop_Set]
	@CompanyId bigint = null
	,@CompanyName varchar(100)
	,@Street1 varchar(200)
	,@Street2 varchar(25)
	,@City varchar(200)
	,@RegionCd varchar(2)
	,@PoCode varchar(10)
	,@PrimaryPhone varchar(15)
	,@PrimaryEmail varchar(100)
	,@ApptPolicy varchar(3000) = ''
	,@UseDST bit = 1
	,@TimeZone varchar(50) = 'Pacific Standard Time'
	,@IsDeleted bit null = 0
	,@ARD varchar(15)
	,@CAAutoServiceLicenseFlag int
	,@BusinessType  varchar(25) = ''

AS
BEGIN TRY

	declare @updated bit = 0

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Begin transaction

	if(@CompanyId is null) begin

		if exists(select 1 from search.CASearchAttribute where ARD = @ARD) begin
			THROW 51001, 'DUPLICATE ARD', 1; 
		end

		if exists(select 1 from search.CASearchAttribute where CompanyName = @CompanyName and CityName = @City and PoCode = @PoCode) begin
			THROW 51001, 'A COMPANY WITH THE SAME NAME CITY AND PO CODE EXISTS', 1; 
		end

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
			,@BusinessType
			,GETUTCDATE()
			,NULL
		)

		select @CompanyId = SCOPE_IDENTITY()

		insert into attribs.AutoServiceAttributes ( CompanyId, LicenseNumber, AutoServiceLicenseFlag, CreateDtTm, CreatedById)
		values (@CompanyId, @ARD, @CAAutoServiceLicenseFlag, GETUTCDATE(), 1 )

		insert into search.CASearchAttribute (CompanyId, ARD,CompanyName,PrimaryPhone,PrimaryEmail,CityName,RegionCd,PoCode,IsEmissionInspector,IsAutoRepair,IsSafetyInspector,IsCleanTruckInspector,CreateDtTm,CreateById)
			values (@CompanyId,@ARD,@CompanyName, @PrimaryPhone,@PrimaryEmail,@City,@RegionCd,@PoCode,1,0,0,0,GETUTCDATE(),1)
	end
	else begin
    -- Insert statements for procedure here
		update Companies set
			CompanyName = isnull(@CompanyName,CompanyName)
			,Street1 = isnull(@Street1,Street1)
			,Street2 = isnull(@Street2,Street2)
			,City = isnull(@City,City )
			,RegionCd = isnull(@RegionCd,RegionCd)
			,PoCode = isnull(@PoCode,PoCode)
			,PrimaryPhone = isnull(@PrimaryPhone,PrimaryPhone)
			,PrimaryEmail = isnull(@PrimaryEmail,PrimaryEmail)
			,ApptPolicy = isnull(@ApptPolicy,ApptPolicy)
			,UseDST = isnull(@UseDST,UseDst)
			,TimeZone = isnull(@TimeZone,TimeZone)
			,UTCUpdateDtTm = GETUTCDATE()
		where CompanyId = @CompanyId

		update attribs.AutoServiceAttributes set
			LicenseNumber = isnull(@ARD, LicenseNumber)
			,AutoServiceLicenseFlag = ISNULL(@CAAutoServiceLicenseFlag,AutoServiceLicenseFlag)
		where CompanyId = @CompanyId

		update search.CASearchAttribute set 
			CompanyName = isnull(@CompanyName ,CompanyName)
			,CityName = isnull(@City,CityName)
			,RegionCd = isnull(@RegionCd,RegionCd)
			,PoCode = isnull(@PoCode,PoCode)
			,PrimaryPhone = isnull(@PrimaryPhone,PrimaryPhone)
			,PrimaryEmail = isnull(@PrimaryEmail,PrimaryEmail)
			,UpdateDtTm = GETUTCDATE()
			,UpdateById = 1
		where CompanyId = @CompanyId


		select @@ROWCOUNT 

	end

	commit

END TRY
BEGIN CATCH
        -- Optionally log error here
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Re-throw the original exception (preserves number, severity, state)
        THROW;
END CATCH