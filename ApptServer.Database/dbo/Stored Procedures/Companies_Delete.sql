CREATE PROCEDURE [dbo].[Companies_Delete]
	@CompanyId bigint null
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


    -- Insert statements for procedure here
		update Companies 
			set isdeleted = 1
		where CompanyId = @CompanyId

		select @@ROWCOUNT 

END