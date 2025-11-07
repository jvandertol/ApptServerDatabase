
CREATE PROCEDURE BaseCompany_Get
	-- Add the parameters for the stored procedure here
	@Id bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
END