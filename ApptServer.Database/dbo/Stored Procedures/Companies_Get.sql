CREATE PROCEDURE [dbo].[Companies_Get]
@Id int
AS
BEGIN
/*
	exec [dbo].[Companies_Get] 1
*/
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @BusinessType varchar(25)

	select @BusinessType = BusinessType from dbo.companies
	where CompanyId = @Id

	--IF @BusinessType = 'Hotel'
	--    EXEC HotelCompany_Get @Id
	--ELSE 
	IF @BusinessType = 'caautoserviceshop'
		EXEC caautoserviceshop_Get @Id
	ELSE
		EXEC BaseCompany_Get @Id
	/*
    -- Insert statements for procedure here
	SELECT 
	CompanyId Id
	,CompanyName Name
	,Street1
	,Street2
	,City
	,RegionCd [State]
	,PoCode
	,PrimaryPhone
	,PrimaryEmail
	,ApptPolicy
	,IsDeleted
	,UTCCreateDtTm
	,UTCUpdateDtTm
	into #baseCompany
	 from dbo.companies
	where CompanyId = @Id
	*/

END