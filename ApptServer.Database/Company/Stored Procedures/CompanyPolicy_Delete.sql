-- =============================================
-- Author:		jtv
-- Create date: 2026-07-17
-- Description:	deletes record by CompanypolicyId if it exists else by matching externalCompanyId and ExternalPolicyId
--- =============================-===============
Create PROCEDURE [Company].[CompanyPolicy_Delete]
	@CompanyPolicyId bigint = null
    ,@ExternalCompanyPolicyId bigint = NULL
    ,@CompanyId bigint = null
    ,@ExternalCompanyId bigint =null
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

	-- check that user is logged in CompanyId will be null if not
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
	if @CompanyPolicyId is null 
		THROW 52002, 'Unable to find policy for the identified CompanyPolicyId.', 1;

	delete from company.CompanyPolicy
		where CompanyPolicyId =	@CompanyPolicyId

	if @@ROWCOUNT = 0 begin
		SET @msg  = 'delete action failed for  ' + ISNULL(@CompanyPolicyId, '<unknown>');
		throw 52004, @msg , 1;
	end
	SELECT @CompanyPolicyId
END