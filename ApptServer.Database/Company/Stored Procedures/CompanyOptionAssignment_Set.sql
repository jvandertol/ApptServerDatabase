-- =============================================
-- Author:		jtv
-- Create date: 2026-0-08
-- Description:	sets or removes an option and its parent.  The option is in OptionCd and GroupCd is the parent.  These are passed or
-- derived from the @Id if that is passed.  The sp inserts the current values where the row OptionCd = @OptionCd or the optionCd = @GroupCd
-- 
-- =============================================
CREATE PROCEDURE [Company].[CompanyOptionAssignment_Set]
	@Id bigint null
	,@OptionCd varchar(15) null
	,@GroupCd varchar(15) null
	,@EffectiveDate Date null
	,@IsEnabled bit
	,@CompanyId bigint null
	,@ExternalCompanyId bigint null
    ,@UserId bigint
AS BEGIN
/*
-- IsEnabled = 0
exec company.CompanyOptionAssignment_Set null,'appt_basic',null,0,null,431,2

-- IsEnabled = 1
exec company.[CompanyOptionAssignment_Set] null,'appt_basic',null,1,null,431,2
*/
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@Id IS NULL AND @CompanyId IS NULL AND @ExternalCompanyId IS NULL) BEGIN
        THROW 50004, 'CompanyId or ExternalCompanyId is required if Id is null', 1;
    END

    IF @CompanyId IS NULL AND @ExternalCompanyId IS NOT NULL BEGIN
        SELECT @CompanyId = CompanyId
        FROM security.CoExternalCoAssoc
        WHERE ExternalCompanyId = @ExternalCompanyId;

        IF @CompanyId IS NULL
        BEGIN
            THROW 50005, 'Invalid ExternalCompanyId', 1;
        END
    END
    
    -- debug
--    select @CompanyId,@OptionCd,@id

    -- Set TargetId
    DECLARE @TargetId BIGINT;
    
    if (@id is not null) begin
        SELECT @TargetId = @Id
    end
    else begin
        select @TargetId = loa.Id
         from Company.LocationOptionAssoc loa 
	        join Company.Options o on o.Id = loa.OptionId
        where optioncd = @optioncd
	        and loa.CompanyId = @CompanyId

    end

    -- debug
--    Select @TargetId target

    -- insert into log then delete
    insert into  Company.LocationOptionAssocLog
    select
        loa.id
        ,loa.OptionId
        ,loa.CompanyId
        ,loa.UTCEffectiveDate
        ,loa.PropertyXml
        ,loa.OverrideCost
        ,UTCCreateDtTm
        ,loa.CreateId
        ,GETUTCDATE() UTCUpdateDtTm
        ,@UserId UpdateId
         from Company.LocationOptionAssoc loa 
       where loa.id = @TargetId
    
    -- delete
    delete
    from Company.LocationOptionAssoc  
       where id = @TargetId
    
-- now if IsEnabled insert
    if(@IsEnabled= 1) begin
        insert into company.LocationOptionAssoc
        select 
            o.Id OptionId
            , @CompanyId
            , isnull(@EffectiveDate, GETUTCDATE()) EffectiveDate
            , null PropertyXml
            , null OverrideCost
            , GETUTCDATE() CreatedDtTm
            , @UserId CreatedId
            , null UTCUpdateDtTm
            ,null UpdateId 
        from Company.Options o
        where optioncd = @optioncd 

    end
END