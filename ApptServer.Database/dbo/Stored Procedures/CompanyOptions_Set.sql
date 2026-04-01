-- =============================================
-- Author:		JTV
-- Create date: 2026-04-10
-- Description:	Sets or updates a company option
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

    DECLARE @TargetId BIGINT;

    SELECT @TargetId = Id
    FROM Company.LocationOptionAssoc
    WHERE 
        (@Id IS NOT NULL AND Id = @Id)
        OR
        (@Id IS NULL AND OptionId = @OptionId AND CompanyId = @CompanyId);


	IF @IsEnabled = 0 begin 
        if( @TargetId is not null) BEGIN
            DELETE FROM Company.LocationOptionAssoc
            WHERE Id = @TargetId;
        end
    END
    ELSE BEGIN
        -- row exists?
        IF( @TargetId is not null ) BEGIN
                UPDATE Company.LocationOptionAssoc
                SET 
                    UTCEffectiveDate = isnull(@EffectiveDate,UTCEffectiveDate),
                    PropertyXml = isnull(CAST(@PropertyXml AS XML),PropertyXml),
                    OverrideCost = isnull(@OverrideCost,OverrideCost),
                    UTCUpdateDtTm = GETUTCDATE(),
                    UpdateId = @UserId
                WHERE 
                    Id = @TargetId;
        END
        ELSE
        BEGIN
            INSERT INTO Company.LocationOptionAssoc(
                OptionId,
                CompanyId,
                UTCEffectiveDate,
                PropertyXml,
                OverrideCost,
                UTCCreateDtTm,
                CreateId,
                UTCUpdateDtTm,
                UpdateId
            )
            VALUES ( @OptionId, @CompanyId, @EffectiveDate, Cast(@PropertyXml as Xml), @OverrideCost, GETUTCDATE(), @UserId,null,null);
        END
    END
END