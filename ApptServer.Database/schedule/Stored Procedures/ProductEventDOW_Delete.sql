-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [schedule].[ProductEventDOW_Delete]
-- missing ExternalPackageId
	@ProductEventDOWId bigint = null
	,@ExternalProductEventDOWId bigint = null
	,@CompanyId bigint = null
	,@ExternalCompanyId bigint = null


	-- Add the parameters for the stored procedure here
AS BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @DOWeventTypeId int = null

	if @ProductEventDOWID = -1
		set @ProductEventDOWID = null

	if @ExternalProductEventDOWId = -1
		set @ExternalProductEventDOWId = null
	
	if @ProductEventDOWId is null AND (@ExternalProductEventDOWId IS NULL OR @ExternalCompanyId IS NULL ) begin
		THROW 52250, 'Either ProductEventDOWId or ExternalProductEventDOWId and @ExternalCompanyId are required', 1; 

	end

	Declare	@msg varchar(250)
	-- this is an external call get CompanyId
	if @ExternalCompanyId is not null and @ProductEventDOWId is null begin
		select @CompanyId = CompanyId from security.CoExternalCoAssoc where ExternalCompanyId = @ExternalCompanyId
	end
	-- get the existing row for DOWEventTypeId
	select @DOWeventTypeId = DOWEventTypeId from schedule.ProductEventDOW dow
		join schedule.ProductEvent pe on dow.ProductEventId = pe.ProductEventId
		where 
			(ProductEventDOWID = @ProductEventDOWID) 
			or 
			(ExternalProductEventDOWId = @ExternalProductEventDOWId and pe.CompanyId = @CompanyId)

	-- this is an external call get ProductEventDOWId
	if @ExternalProductEventDOWId is not null and @ProductEventDOWId is null begin
		select @ProductEventDOWId = ProductEventDOWId from schedule.ProductEventDOW pdow
			join schedule.ProductEvent pe on pdow.ProductEventId = pe.ProductEventId
		where ExternalProductEventDOWID = @ExternalProductEventDOWId
			and pe.CompanyId = @CompanyId 
	end

	if @ProductEventDOWId is null
		THROW 52254, 'Null ProductEventDOWId present after search using external Ids', 1; 

	-- 1 is daily schedule set start and end to null
	if @DOWeventTypeId = 1 begin
		update schedule.ProductEventDOW
			set ScheduledStartingTime = null
			,UTCScheduledStartingTime = NULL
			,UTCScheduledEndingTime = NULL
			,ScheduledEndingTime = null
		where ProductEventDOWID = @ProductEventDOWId

		If @@ROWCOUNT = 0
			throw 52255, 'Update of daily schedule failed', 1; 

	end
	else begin
		delete from schedule.ProductEventDOW
			where ProductEventDOWID = @ProductEventDOWId

		If @@ROWCOUNT = 0
			throw 52256, 'Delete of daily schedule failed', 1; 
	end

	SELECT @ProductEventDOWId
END