-- =============================================
-- Author:		JTV
-- Create date: 2026-04-10
-- Description:	Inserts/Updates a row in the company.option table 
-- =============================================
CREATE PROCEDURE [dbo].[CompanyOptions_Set]
--long? Id, long OptionId, long? CompanyId, DateOnly? EffectiveDate, long? ExternalCompanyId, string? PropertyXml, decimal? OverrideCost, bool IsEnabled) : AuthenticatedBaseRecordDTO, IRequest<ErrorOr<bool>>;

	@Id bigint = null,
	@OptionId bigint
	,@CompanyId bigint = null
    ,@ExternalCompanyId bigint = null
	,@EffectiveDate date = null
	,@PropertyXml varchar(max) = null
	,@OverrideCost money = null
    ,@UserId bigint
	,@isEnabled bit

AS BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

        THROW 50004, 'Not implemented', 1;

END