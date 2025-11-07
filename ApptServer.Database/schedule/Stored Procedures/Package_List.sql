-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [schedule].[Package_List]
	@Id bigint null
	,@Origin varchar(250) null
	,@YearGroupid int = 1
	,@FuelTypeCd varchar(25)
	,@VehicleTypeCd varchar(25)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@id is null) begin
		select @Id = CompanyId from security.AllowedURLs where url = @Origin
	end

    -- Insert statements for procedure here
	SELECT p.PackageId,PackageName,Price FROM schedule.Package p
	WHERE 
	p.CompanyId = @Id 
	and PackageXml.exist('
		/asonlinepkgcriteria/criterion[
			@yeargroupid = sql:variable("@YearGroupId")
			and @fueltypecd = sql:variable("@FuelTypeCd")
			and @vehicletypecd = sql:variable("@VehicleTypeCd")
		]
	') = 1;

	--and PackageXml.value('(/*[1]/yeargroupid/@value)[1]','int') = @YearGroupid
	--and PackageXml.value('(/*[1]/fueltypeid/@value)[1]','varchar(25)') = @FuelTypeCd
	--and PackageXml.value('(/*[1]/vehicletypeid/@value)[1]','varchar(25)') = @VehicleTypeCd
	

END