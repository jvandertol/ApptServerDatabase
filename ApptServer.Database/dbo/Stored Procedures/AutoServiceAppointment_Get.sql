-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AutoServiceAppointment_Get]
@Id bigint 
AS
BEGIN TRY
	-- exec [AutoServiceAppointment_Get] 1
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select 
		a.AppointmentId Id
		,a.StartDtTm
		,a.EndDtTm
		,p.EstDurationMins
		,a.ApptStatusId
		,u.FirstName CustFirstName
		,u.LastName CustLastName
		,u.Email ApptUserEmail
		,u.PhoneNumber ApptUserPhone
		,p.PackageId
		,p.PackageName
		,p.Price
		,yt.YearTypeId
		,yt.YearType
		,ft.FuelTypeCd
		,ft.Name FuelType
		,vt.VehicleTypeCd
		,vt.Name VehicleType
		,c.CompanyName ShopName
		,c.Street1 + isnull(c.Street2,'') ShopAddress
		,c.City ShopCityName
		,c.RegionCd ShopRegionName
		,c.PoCode ShopPostalCode
		,c.PrimaryPhone ShopPhoneNumber
		,c.PrimaryEmail ShopEmail
		,c.ApptPolicy
	from Appointments a
		join attribs.AutoServiceApptAttrib aat on a.AppointmentId = aat.AppointmentId
		join schedule.YearTypes yt on aat.YearTypeId = yt.YearTypeId
		join schedule.FuelTypes ft on aat.FuelTypeCd = ft.FuelTypeCd
		join schedule.VehicleTypes vt on aat.VehicleTypeCd = vt.VehicleTypeCd
		join schedule.Package p on a.PackageId = p.PackageId
		join users u on a.UserId = u.UserId
		join Companies c on a.CompanyId = c.CompanyId
	where a.AppointmentId = @Id

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