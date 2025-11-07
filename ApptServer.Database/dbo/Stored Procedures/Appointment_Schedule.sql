-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Appointment_Schedule] 
	-- Add the parameters for the stored procedure here
	@Id bigint null -- CompanyId
	,@Origin varchar(250) null
	,@PackageId bigint
	,@StartDate date
AS
BEGIN TRY

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/*
	exec [dbo].[Appointment_Schedule] 1, 2,'2025-02-18'
*/


declare 
	@endDate date
	--,@numDays int = 3
	,@UseDST bit
	,@tzName varchar(200)
	,@CallingProcedure varchar(100)
	,@numDays int = 3


	SELECT @CallingProcedure    = OBJECT_NAME(@@procid)

	if(@id is null) begin
		select @id = companyid from security.AllowedURLs where url = @Origin
	end
	    
	if @id is null or @PackageId is null or @StartDate IS NULL begin
		RAISERROR('id is required',11,1,@CallingProcedure )
	end


	--select @UseDST = isnull(sic.useDST,1),  @tzName = isnull(tzName,'Pacific Standard Time') from idbtest4.ServiceInstanceContainer sic where ServiceInstanceContainerId  = @sic
	select @UseDST = 1
	
	-- the CTE needs to consider closed days DOWEventTypeId = 4
	if @numDays > 1 begin
		declare @daysBefore int
		select @daysBefore = cast(@numdays/2 as int)*-1
		select  @startDate = case when dateadd(dd,@daysBefore, @startDate) < getdate() then getdate() else dateadd(dd,@daysBefore, @startDate) end
		select  @endDate =  dateAdd(dd,@numDays+@daysBefore+abs(@daysBefore)-1, @startDate)
	end

	declare @d int
	set @d = DATEPART(dw,@startDate)

	;WITH cte AS (
		SELECT CASE WHEN DATEPART(dw,@StartDate) = @d THEN @StartDate 
					ELSE DATEADD(d,DATEDIFF(d,0,@StartDate)+1,0) END AS myDate
		UNION ALL
		SELECT DATEADD(d,1,myDate)
		FROM cte
		WHERE DATEADD(d,1,myDate) <=  @EndDate
		)
		SELECT 
		myDate
		,datediff(day, '1/1/1900',mydate) dateOrder 
		into #tmpApp
		FROM cte
		OPTION (MAXRECURSION 0)

	--select * from #tmpApp

	--select ProductEventStartDt ClosedDay from  idbtest4.ProductEvent pe 
	--	join schedule.ProductEventDOW  dow on pe.ProductEventID = dow.ProductEventID 
	--	where pe.ServiceInstanceContainerID = @sic and dow.DOWeventTypeId = 4 
	--	and MONTH( ProductEventStartDt) = month(@startDate) and year(ProductEventStartDt)  = year(@startDate)

	select 
	@startDate StartingDate  
	,@numDays dayCount 
--	,pe.DOWOperation 
	,isnull(c.TimeZone,'Pacific Standard Time') tzName
	,c.CompanyId 
	,c.CompanyName ShopName
	from Companies c where c.CompanyId = @id

	select 
		@PackageId PackageId
		,EstDurationMins 
	from schedule.Package p 
		where p.PackageID = @PackageId

	select 
		dow.DOW
		,CONVERT(varchar(5), dow.ScheduledStartingTime, 108)  ScheduledStartingTime
		,CONVERT(varchar(5), dow.ScheduledEndingTime, 108)  ScheduledEndingTime
		,dow.DOWeventTypeId
		,t.dateOrder
		,t.myDate operatingDate 
	from schedule.ProductEventDOW dow
		join schedule.ProductEvent pe on pe.ProductEventId = dow.productEventId
		join #tmpApp t on dow.DOW = power(2.0, datepart(dw,myDate)-1)
	where pe.CompanyId= @Id
		and dow.DOWeventTypeId in (1,3)
		and dow.ScheduledStartingTime is not null and dow.ScheduledEndingTime is not null  -- needs to be changed.  Null values are valid.
		order by dow, ScheduledStartingTime

/*
--	 hard coded appointments for testing as no appointment table exists
	select
		cast(concat(@StartDate, ' 14:00') as datetime) StartDtTm
		,cast(concat(@StartDate, ' 14:20') as datetime) EndDtTm union all
	select
		cast(concat(dateadd(d,1,@StartDate), ' 14:00') as datetime) StartDtTm
		,cast(concat(dateadd(d,1,@StartDate), ' 14:20') as datetime) EndDtTm
*/

 select a.StartDtTm, a.EndDtTm from Appointments a
		join Companies c on a.CompanyId = c.CompanyId
	where 
			a.StartDtTm between @startDate and dateadd(day,1,@endDate)
			and c.CompanyId = @id
	order by a.StartDtTm

END TRY
BEGIN CATCH
	BEGIN
		-- Whoops, there was an error
		IF @@TRANCOUNT > 0
		ROLLBACK
		-- Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(),
		@ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END 
END CATCH