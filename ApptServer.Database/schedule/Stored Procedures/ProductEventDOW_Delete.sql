-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [schedule].[ProductEventDOW_Delete]
-- missing ExternalPackageId
	@ProductEventDOWId bigint = null
	,@ExternalProductEventDOWId bigint = null

	-- Add the parameters for the stored procedure here
AS BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @Id bigint = isnull(@ProductEventDOWId,@ExternalProductEventDOWId)
	,@DOWeventTypeId int = null
	/*
	-- EXAMPLES OF THROW
	if exists(select 1 from search.CASearchAttribute where ARD = @ARD) begin
			THROW 51001, 'DUPLICATE ARD', 1; 
		end

		if exists(select 1 from search.CASearchAttribute where CompanyName = @CompanyName and CityName = @City and PoCode = @PoCode) begin
			THROW 51001, 'A COMPANY WITH THE SAME NAME CITY AND PO CODE EXISTS', 1; 
		end
	*/

	if @Id is null begin
		THROW 52000, 'Either ProductEventDOWId or ExternalProductEventDOWId is required', 1; 

	end

	-- get the existing row for DOWEventTypeId
	select @DOWeventTypeId = DOWEventTypeId from schedule.ProductEventDOW 
		where (ProductEventDOWID = isnull(@ProductEventDOWID,ProductEventDOWID) and ExternalProductEventDOWId = isnull(@ExternalProductEventDOWId, ExternalProductEventDOWId))

	-- 1 is daily schedule set start and end to null
	if @DOWeventTypeId = 1 begin
		update schedule.ProductEventDOW
			set ScheduledStartingTime = null
			,UTCScheduledStartingTime = NULL
			,UTCScheduledEndingTime = NULL
			,ScheduledEndingTime = null
		where (ProductEventDOWID = isnull(@ProductEventDOWID,ProductEventDOWID) and ExternalProductEventDOWId = isnull(@ExternalProductEventDOWId, ExternalProductEventDOWId))

	end
	else begin
		delete from schedule.ProductEventDOW
			where (ProductEventDOWID = isnull(@ProductEventDOWID,ProductEventDOWID) and ExternalProductEventDOWId = isnull(@ExternalProductEventDOWId, ExternalProductEventDOWId))

	end

	SELECT @Id
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