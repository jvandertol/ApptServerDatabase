-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Appointment_Initialize]
	-- Add the parameters for the stored procedure here
	@Origin varchar(50) 
AS
BEGIN 

	SET NOCOUNT ON;

	declare @CompanyId bigint 
	select @CompanyId = CompanyId from security.AllowedURLs where Url = @Origin

    -- create temp table
	create table #tmp (
		CompanyId				bigint,
		Name			varchar(100),
		ARD				varchar(25),
		CAAutoServiceLicenseFlag bit,
		Street1			varchar(200),
		Street2			varchar(25),
		City			varchar(200),
		State			varchar(2),
		PoCode			varchar(10),
		PrimaryPhone	varchar(15),
		PrimaryEmail	varchar(100),
		ApptPolicy		varchar(3000),
		IsDeleted		bit,
		BusinessType    varchar(100),
		UTCCreateDtTm	datetime2(3),
		UTCUpdateDtTm	datetime2(3),
	)

	insert into #tmp 
	exec companies_get @CompanyId

	select 
		CompanyId				
		,Name			ShopName	
		,ARD
		,CAAutoServiceLicenseFlag
		,Street1		
		,Street2			
		,City			ShopCityName
		,State			ShopRegionName
		,PoCode			ShopPostalCode
		,PrimaryPhone	ShopPhoneNumber
		,PrimaryEmail	ShopEmail
		,ApptPolicy		
	from #tmp

	select yt.YearTypeId, YearType [Name] from schedule.YearTypes yt
		join schedule.YearTypeCoAssoc ytca on yt.YearTypeId = ytca.YearTypeId and ytca.CompanyId = @CompanyId

	select vt.* from schedule.vehicletypes vt
		join schedule.VehTypeCoAssoc vtca on vt.VehicleTypeId = vtca.VehicleTypeId and vtca.CompanyId = @CompanyId

	select ft.* from schedule.fuelTypes ft
		join schedule.FuelTypeCoAssoc ftca on ft.FuelTypeId = ftca.FuelTypeId and ftca.CompanyId = @CompanyId

END