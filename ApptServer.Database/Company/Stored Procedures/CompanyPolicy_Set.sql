-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Company].[CompanyPolicy_Set]
	@CompanyPolicyId bigint = null
    ,@ExternalCompanyPolicyId bigint = NULL
    ,@CompanyId bigint = null
    ,@ExternalCompanyId bigint =null
    ,@PolicyTypeId tinyint
    ,@Policy varchar(2500)
	,@UserId bigint
	-- Add the parameters for the stored procedure here
AS BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	if @CompanyPolicyId = -1
		set @CompanyPolicyId = null

	if @ExternalCompanyPolicyId = -1
		set @ExternalCompanyPolicyId = null

	IF @CompanyId IS NULL AND @ExternalCompanyId IS NULL
		THROW 52000, 'CompanyId or ExternalCompanyId is required.', 1;

	IF @CompanyPolicyId IS NOT NULL AND @CompanyId IS NULL
	    THROW 52001, 'CompanyId is required when CompanyPolicyId is supplied.', 1;

	IF @CompanyPolicyId IS NOT NULL AND @ExternalCompanyPolicyId IS NOT NULL
		THROW 52002, 'CompanyPolicyId and ExternalCompanyPolicyId cannot both be supplied.', 1;

	Declare  @msg varchar(250)
	-- this is an external call get CompanyId

	-- get native keys for external calls
	IF @ExternalCompanyId IS NOT NULL
	    SELECT @CompanyId = CompanyId FROM security.CoExternalCoAssoc  WHERE ExternalCompanyId = @ExternalCompanyId;

	IF @ExternalCompanyPolicyId IS NOT NULL
		SELECT @CompanyPolicyId = CompanyPolicyId FROM company.CompanyPolicy WHERE ExternalCompanyPolicyId = @ExternalCompanyPolicyId AND CompanyId = @CompanyId;
		
	-- this is an insert
	if @CompanyPolicyId is null  begin
	--select * from INFORMATION_SCHEMA.columns where table_name = 'companypolicy'
		insert into company.CompanyPolicy (ExternalCompanyPolicyId, CompanyId, PolicyTypeId, [Policy], CreateDtTm, CreatedById)
		select 
			@ExternalCompanyPolicyId
			,@CompanyId
			,@PolicyTypeId
			,@Policy
			,GETUTCDATE()
			,@UserId
	
		select @CompanyPolicyId = SCOPE_IDENTITY()
		if @CompanyPolicyId is null begin
			SET @msg  = 'Insert action failed for event ' + ISNULL(@Policy, '<unknown>');
			throw 52003, @msg , 1;
		end

	end
	else begin
		update company.CompanyPolicy
		set 
			PolicyTypeId = case when @PolicyTypeId is null then PolicyTypeId else @PolicyTypeId end
			,Policy = case when @Policy is null then [Policy] else @Policy end
			,UpdateDtTm = GETUTCDATE()
			,UpdatedById = @UserId
		where CompanyPolicyId =	@CompanyPolicyId

		if @@ROWCOUNT = 0 begin
			SET @msg  = 'Update action failed for event ' + ISNULL(@Policy, '<unknown>');
			throw 52004, @msg , 1;
		end
	end
	SELECT @CompanyPolicyId
END