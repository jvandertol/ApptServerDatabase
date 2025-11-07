-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AutoServiceAppointment_Set]
	@AppointmentId bigint
	,@PackageId bigint
	,@StartDtTm datetime2
	,@ApptStatusId smallint
	,@VehicleId bigint
	,@YearTypeId smallint 
	,@VehicleTypeCd varchar(10)
	,@FuelTypeCd varchar(10)
	,@UserId bigint
	,@Origin varchar(250)
--	,@ReturnValue bigint OUTPUT
AS
BEGIN TRY
/*
	-- check for duplicate
	exec [AutoServiceAppointment_Set] null, 2, '2025-05-09 14:30:00', 2, null, 1,'v1','fueltype-1',17,'https://localhost:5176'
*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Insert statements for procedure here

	declare @Duration int
	,@useDST bit
	,@TimeZone varchar(200)
	,@ApptId bigint = null
	,@CompanyId bigint

	-- from the packageId get the duration
	select @Duration = EstDurationMins from schedule.Package with (nolock) where PackageId = @PackageId

	-- from the userid get the company and if they UseDST and TimeZone
	select @useDST = useDST, @TimeZone = TimeZone, @CompanyId = c.CompanyId from Companies c with (nolock)
		join security.AllowedURLs au on c.CompanyId = au.CompanyId
	where au.url = @Origin

	begin transaction

	if(@AppointmentId is null) begin
		-- insert into appointment calcing UTC from TimeZone
	--	insert into appointments values (
	----	AppointmentId
	--		@UserId
	--		,@CompanyId
	--		,@PackageId
	--		,@StartDtTm
	--		,DATEADD(MINUTE,@duration,@startdttm) --ENDDATE
	--		,@AppTStatusId
	--		,CAST(@startdttm AT TIME ZONE 'UTC' AT TIME ZONE case when @useDST = 0 then 'US '+ @TimeZone else @TimeZone end as datetime2) -- @UTCStartDtTm
	--		,CAST(dateadd(MINUTE,@duration,@startdttm) AT TIME ZONE 'UTC' AT TIME ZONE case when @useDST = 0 then 'US '+ @TimeZone else @TimeZone end as datetime2)-- calc it @UTCEndDtTm
	--		,CAST(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE case when @useDST = 0 then 'US '+ @TimeZone else @TimeZone end as datetime2)-- @CreateDtTm 
	--		,GETUTCDATE() -- UTCCreateDtTm
	--		,@UserId -- CreateById
	--		,null -- UpdateDtTm
	--		,null -- UTCUpdateDtTm
	--		,null -- UpdateById
	--	)

		INSERT INTO Appointments (
			UserId,
			CompanyId,
			PackageId,
			StartDtTm,
			EndDtTm,
			AppTStatusId,
			UTCStartDtTm,
			UTCEndDtTm,
			CreateDtTm,
			UTCCreateDtTm,
			CreateById,
			UpdateDtTm,
			UTCUpdateDtTm,
			UpdateById
		)
		SELECT
			@UserId,
			@CompanyId,
			@PackageId,
			@StartDtTm,
			DATEADD(MINUTE, @duration, @StartDtTm), -- EndDtTm
			@AppTStatusId,
			CAST(@StartDtTm AT TIME ZONE 'UTC' AT TIME ZONE CASE WHEN @useDST = 0 THEN 'US ' + @TimeZone ELSE @TimeZone END AS datetime2),
			CAST(DATEADD(MINUTE, @duration, @StartDtTm) AT TIME ZONE 'UTC' AT TIME ZONE CASE WHEN @useDST = 0 THEN 'US ' + @TimeZone ELSE @TimeZone END AS datetime2),
			CAST(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE CASE WHEN @useDST = 0 THEN 'US ' + @TimeZone ELSE @TimeZone END AS datetime2),
			GETUTCDATE(),
			@UserId,
			NULL,
			NULL,
			NULL
		WHERE NOT EXISTS (
			SELECT 1
			FROM Appointments a
			WHERE a.CompanyId = @CompanyId
			  AND (
				   @StartDtTm < a.EndDtTm AND DATEADD(MINUTE, @duration, @StartDtTm) > a.StartDtTm
				  )
		);

		select @ApptId = SCOPE_IDENTITY()

		if( @ApptId is null) begin
			select @ApptId = -1
		end 
		else begin
			insert into attribs.AutoServiceApptAttrib values (
				@ApptId
				,@VehicleId
				,@YearTypeId
				,@VehicleTypeCd
				,@FuelTypeCd
			)
		end
	end
	else begin
		update appointments set 
			-- allow this, but the package should not be a of a different duration than the existing
			PackageId = isnull(@PackageId, PackageId)
			-- should not be able to update times.  Changing of time requires a new appointment
			--,StartDtTm = isnull(@StartDtTm,StartDtTm)
			--,EndDtTm = isnull(@StartDtTm,EndDtTm)
			,@ApptStatusId = isnull(@ApptStatusId, ApptStatusId)
			-- should not be able to update times.  Changing of time requires a new appointment
			--,UTCStartDtTm = case when @startdttm is null then StartDtTm else CAST(@startdttm AT TIME ZONE 'UTC' AT TIME ZONE case when @useDST = 0 then 'US '+ @TimeZone else @TimeZone end as datetime2) end
			--,UTCEndDtTm = case when @startdttm is null then EndDtTm else CAST(dateadd(MINUTE,@duration,@startdttm) AT TIME ZONE 'UTC' AT TIME ZONE case when @useDST = 0 then 'US '+ @TimeZone else @TimeZone end as datetime2) end
			,UpdateDtTm= CAST(GETUTCDATE() AT TIME ZONE 'UTC' AT TIME ZONE case when @useDST = 0 then 'US '+ @TimeZone else @TimeZone end as datetime2) -- UpdateDtTm
			,UTCUpdateDtTm= GETUTCDATE() -- UTCUpdateDtTm
			,UpdateById= @UserId -- UpdateById
		where AppointmentId = @AppointmentId


		update attribs.AutoServiceApptAttrib set
			VehicleId = isnull(@VehicleId, VehicleId)
			,YearTypeId= isnull(@YearTypeId, YearTypeId)
			,VehicleTypeCd= isnull(@VehicleTypeCd, VehicleTypeCd)
			,FuelTypeCd= isnull(@FuelTypeCd, FuelTypeCd)
		where @AppointmentId = @appointmentId
	end

	commit
	
	select @ApptId

END TRY
BEGIN CATCH
 DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    -- Get the error details
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Rollback the transaction if it's still open
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
    END
    -- Log the error or raise it
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH