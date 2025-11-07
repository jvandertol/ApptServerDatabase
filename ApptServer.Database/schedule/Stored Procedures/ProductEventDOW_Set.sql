-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [schedule].[ProductEventDOW_Set]
	@ProductEventDOWId bigint = null
	,@ExternalProductEventDOWId bigint = null
	,@DOW int
	,@EventStartDt datetime2(3) = null
	,@StartTime time = null
	,@EventEndDt datetime2(3) = null
	,@EndTime time = null
	,@DOWeventTypeId int
	,@DOWeventDescr varchar(200) = null
	,@ExternalCompanyId bigint

	-- Add the parameters for the stored procedure here
AS BEGIN TRY
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

	if (@ProductEventDOWId is null and @ExternalProductEventDOWId is null )
		throw 71001, 'ProductEventDOWId or ExternalProductEventDOWId is required', 1;

	if @ExternalProductEventDOWId is not null and @ProductEventDOWId is null begin
		select @ProductEventDOWId = ProductEventDOWId from schedule.ProductEventDOW where ExternalProductEventDOWID = @ExternalProductEventDOWId
	end

	if @ProductEventDOWId is null  begin

		declare @ProductEventId bigint
		,@TimeZone NVARCHAR(50)
		,@UTCDateTime datetime2(3)

		-- join to security.CoExternalCoAssoc unnecessary after ExternalCompanyId added to Company table
		select 
			@ProductEventId = pe.ProductEventId
			,@TimeZone = isnull(c.timezone,'Pacific Standard Time')
			from ProductEvent pe
			join security.CoExternalCoAssoc ceca on pe.companyid = ceca.CompanyId
			join Companies c on pe.CompanyId = c.CompanyId
		where ceca.ExternalCompanyId =  @ExternalCompanyId

		select top 1 * from schedule.ProductEventDOW 

		insert into schedule.ProductEventDOW (
			ExternalProductEventDOWId 
			,ProductEventId
			,DOW
			,ProductEventStartDt
			,UTCProductEventStartDt
			,ScheduledStartingTime
			,ProductEventEndDt
			,UTCProductEventEndDt
			,ScheduledEndingTime 
			,DOWeventTypeId
			,DOWeventDescr
			,CreateDtTm
			,CreatedById)
		select
			@ExternalProductEventDOWId 
			,@ProductEventId
			,@DOW
			,@EventStartDt
			,CAST(@EventStartDt AT TIME ZONE @TimeZone AT TIME ZONE 'UTC' AS datetime2(3))
			,@StartTime
			,@EventEndDt
			,CAST(@EventEndDt AT TIME ZONE @TimeZone AT TIME ZONE 'UTC' AS datetime2(3))
			,@EndTime 
			,@DOWeventTypeId
			,@DOWeventDescr 
			,GETUTCDATE()
			,1
			
	
		select @ProductEventDOWId = SCOPE_IDENTITY()
	end
	else begin
		update schedule.ProductEventDOW
			set 
			DOW = isnull(@DOW,DOW)
			,ProductEventStartDt  = isnull(@EventStartDt,ProductEventStartDt)
			,UTCProductEventStartDt = isnull(CAST(@EventStartDt AT TIME ZONE @TimeZone AT TIME ZONE 'UTC' AS datetime2(3)),UTCProductEventStartDt)
			,ScheduledStartingTime = isnull(@StartTime,ScheduledStartingTime)
			,ProductEventEndDt = isnull(@EventEndDt,ProductEventEndDt)
			,UTCProductEventEndDt = isnull(CAST(@EventEndDt AT TIME ZONE @TimeZone AT TIME ZONE 'UTC' AS datetime2(3)),UTCProductEventEndDt)
			,ScheduledEndingTime  = isnull(@EndTime,ScheduledEndingTime)
			,DOWeventTypeId = isnull(@DOWeventTypeId,DOWeventTypeId)
			,DOWeventDescr = isnull(@DOWeventDescr,DOWeventDescr)
			,UpdateDtTm = GETUTCDATE()
			,UpdatedById = 1

		where (ProductEventDOWID = isnull(@ProductEventDOWID,ProductEventDOWID) and ExternalProductEventDOWId = isnull(@ExternalProductEventDOWId, ExternalProductEventDOWId))

	end

	SELECT isnull(@ProductEventDOWId,@ExternalProductEventDOWId)
END TRY
BEGIN CATCH
        -- Optionally log error here
  --  IF ERROR_NUMBER() IN (2601, 2627) BEGIN
		--DECLARE @errMsg nvarchar(4000) = ERROR_MESSAGE();
  --      THROW 52001, 'A package with that name already exists.', 1;
  --  END
  --  ELSE BEGIN
        THROW;
  --  END
END CATCH