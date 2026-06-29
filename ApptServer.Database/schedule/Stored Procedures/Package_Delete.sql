-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [schedule].[Package_Delete]
-- missing ExternalPackageId
	@PackageId bigint = null
	,@ExternalPackageId bigint = null
	,@ExternalCompanyId bigint = null
	,@CompanyId bigint = null
	-- Add the parameters for the stored procedure here
AS BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
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
-- schedule.PkgCoAssoc table exists because the ExternalPackageId column does not exist in the schedule.Packages table and it should.  The query would still exist but it would go against the schedule.Packages  table
		select @PackageId = PackageId from schedule.PkgCoAssoc where ExternalPackageId = @ExternalPackageId
-- security.CoExternalCoAssoc table exists because the ExternalCompanyId column does not exist in the Company table and it should.  The query would still exist but it would go against the company table
		select @CompanyId = CompanyId from security.CoExternalCoAssoc where ExternalCompanyId = @ExternalCompanyId

	end

	-- A company must exist, and it must be associated with an external company
	if @CompanyId is null begin
		THROW 52003, 'Unable to map external company', 1; 
	end

	if  @CompanyId is null begin
			THROW 52004, 'Unable to map CompanyId', 1; 
	end

	delete from schedule.Package 
	where PackageId = @PackageId and CompanyId = @CompanyId

	-- remove assoc
	if @ExternalPackageId is not null begin
		delete from schedule.PkgCoAssoc  where ExternalPackageId = @ExternalPackageId and ExternalCompanyId = @ExternalCompanyId
	end


	-- update vehicle type supported 
	DELETE
		FROM schedule.VehTypeCoAssoc
		WHERE CompanyId = @CompanyId;

	INSERT INTO schedule.VehTypeCoAssoc
		(
			CompanyId,
			VehicleTypeId
		)
		SELECT DISTINCT
			P.CompanyId,
			VT.VehicleTypeId
		FROM schedule.Package P
		CROSS APPLY P.PackageXml.nodes('/asonlinepkgcriteria/criterion') AS X(C)
		INNER JOIN schedule.VehicleTypes VT
			ON VT.VehicleTypeCd =
			   X.C.value('@vehicletypecd', 'varchar(10)')
		WHERE P.CompanyId = @CompanyId
		  AND P.PackageXml IS NOT NULL;

	-- update fuel type supported 
	DELETE
		FROM schedule.FuelTypeCoAssoc
		WHERE CompanyId = @CompanyId;

	INSERT INTO schedule.FuelTypeCoAssoc
		(
			CompanyId,
			FuelTypeId
		)
		SELECT DISTINCT
			P.CompanyId,
			FT.FuelTypeId
		FROM schedule.Package P
		CROSS APPLY P.PackageXml.nodes('/asonlinepkgcriteria/criterion') AS X(C)
		INNER JOIN schedule.FuelTypes FT
			ON FT.FuelTypeCd =
			   X.C.value('@fueltypecd', 'varchar(10)')
		WHERE P.CompanyId = @CompanyId
		  AND P.PackageXml IS NOT NULL;

	SELECT @PackageId
END