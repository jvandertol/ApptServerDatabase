-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [schedule].[UpSertPackage_Set]
-- missing ExternalPackageId
	@PackageId bigint = null
	,@ExternalPackageId bigint = null
	,@PackageName varchar(200) = null
	,@SinglePriceFlag bit = null
	,@CompanyId bigint = null
	,@ExternalCompanyId bigint = null
  	,@PackageXml varchar(max)
  	,@EstDurationMins int = null
  	,@ShowPriceOnline bit = 1
	,@Price decimal(7,2)  = null
	-- Add the parameters for the stored procedure here
AS BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @isNewRow bit = 0
	/*
	-- EXAMPLES OF THROW
	if exists(select 1 from search.CASearchAttribute where ARD = @ARD) begin
			THROW 51001, 'DUPLICATE ARD', 1; 
		end

		if exists(select 1 from search.CASearchAttribute where CompanyName = @CompanyName and CityName = @City and PoCode = @PoCode) begin
			THROW 51001, 'A COMPANY WITH THE SAME NAME CITY AND PO CODE EXISTS', 1; 
		end
	*/

	if @PackageId is null and @ExternalPackageId is null begin
		THROW 52000, 'Either pakcageid or externalpackageid is required', 1; 

	end

	-- if externalpackageid is populated, check in table to see if package exist in assoc table
	if(@ExternalPackageId is not null) begin
		select @PackageId = PackageId from schedule.PkgCoAssoc where ExternalPackageId = @ExternalPackageId
		select @CompanyId = CompanyId from security.CoExternalCoAssoc where ExternalCompanyId = @ExternalCompanyId

	end

	-- A company must exist, and it must be associated with an external company
	if @CompanyId is null begin
		THROW 52003, 'Unable to map external company', 1; 
	end

	if @PackageId is null begin
		INSERT INTO schedule.Package
		( PackageName,SinglePriceFlag,CompanyId,PackageXml,EstDurationMins,ShowPriceOnline,Price)
		values (
			 @PackageName,@SinglePriceFlag,@CompanyId,@PackageXml,@EstDurationMins,@ShowPriceOnline,@Price
		)
		select @PackageId = SCOPE_IDENTITY()

		insert into schedule.PkgCoAssoc 
			(PackageId,ExternalPackageId,CreateDtTm,CreateById)
		values
			(@PackageId,@ExternalPackageId,getutcdate(),1)

	end
	else begin
		update schedule.Package
			set
				PackageName			= ISNULL(@PackageName,PackageName)
				,SinglePriceFlag	= isnull(@SinglePriceFlag,SinglePriceFlag)
				,PackageXml			= isnull(cast(@PackageXml as xml),PackageXml)
				,EstDurationMins	= isnull(@EstDurationMins,EstDurationMins)
				,ShowPriceOnline	= isnull(@ShowPriceOnline,ShowPriceOnline)
				,Price				= isnull(@price,price)
		where PackageId = @PackageId

	end

	SELECT @PackageId
END TRY
BEGIN CATCH
        -- Optionally log error here
    IF ERROR_NUMBER() IN (2601, 2627) BEGIN
		DECLARE @errMsg nvarchar(4000) = ERROR_MESSAGE();
        THROW 52001, 'A package with that name already exists.', 1;
    END
    ELSE BEGIN
        THROW;
    END
END CATCH