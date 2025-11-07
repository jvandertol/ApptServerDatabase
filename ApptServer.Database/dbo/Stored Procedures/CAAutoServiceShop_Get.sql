
CREATE PROCEDURE [dbo].[CAAutoServiceShop_Get]
	-- Add the parameters for the stored procedure here
	@Id bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		c.CompanyId Id
		,CompanyName Name
		,asa.LicenseNumber ARD
		,asa.AutoServiceLicenseFlag CAAutoServiceLicenseFlag
		,Street1
		,Street2
		,City
		,RegionCd [State]
		,PoCode
		,PrimaryPhone
		,PrimaryEmail
		,ApptPolicy
		,IsDeleted
		,BusinessType
		,UTCCreateDtTm
		,UTCUpdateDtTm
		from dbo.companies c
			join attribs.AutoServiceAttributes asa on c.CompanyId = asa.CompanyId
		where c.CompanyId = @Id
END