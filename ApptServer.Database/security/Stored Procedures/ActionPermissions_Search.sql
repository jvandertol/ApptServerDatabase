-- =============================================
-- Author:				JTV
-- Create date:			2026-03-27
-- Description:			returns a list of claims for the passed CompanyId or ExternalCompanyId.  As it is a search it contains the standard search params
-- @PageNumber:			Current page number
-- @PageId:				Current page Id
-- @Forward:			Direction
-- @PageSize:			number of rows to return
-- @MaxPages:			Combination of short domain:claim value
-- @CompanyId:			The CompanyId of the logged in user
-- @ExternalCompanyId:	The externalCompanyId of the company that is to be impersonated.  Only populated when called by an impersonating web service
-- @Roles:				A table value param as multiple roles may be supported.
-- Description:			The sp runs off the security.PermissionAssoc table which is a domain permission table.  It also identifies if the permission as associated
--						with a companyOption  IsOptionControlled.  The tables ultimately join up to a role.  The data returned is then compared to the requested claims
--						in the claim behavior pipeline
-- =============================================

CREATE PROCEDURE [security].[ActionPermissions_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@CompanyId bigint,
@ExternalCompanyId bigint = null,
@Roles security.RoleList READONLY

AS BEGIN
/*
declare @r1 security.RoleList
insert into @r1 values ('SysAdminAPI')

exec [security].[ActionPermissions_Search]  0,1,1,20,3,2,NULL,@r1

*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- similary to AllowedUrls_Search - the paged list is a stub as the search method expects it

	-- if an @ExternalCompanyId is passed replace @CompanyId with the company associated with that external id.  This is so that in the case of impersonation options
	-- a calling web service can only impersonate permissions granted to the user
	declare @EffectiveCompanyId bigint
	SELECT @EffectiveCompanyId = CASE WHEN @ExternalCompanyId IS NULL THEN 
			@CompanyId
        ELSE ( 
			SELECT CompanyId FROM security.CoExternalCoAssoc
				WHERE ExternalCompanyId = @ExternalCompanyId
        )
    END;

	-- Search requires a paging table to be returned
	select 1 PageNumber, 1 FirstId, 1 LastId

		select 
		pa.PermissionAssocId Id
		,ISNULL(ora.PermissionScopeId, 1) Scope
		,ct.ClaimTypeKey
		,r.RoleName
		,d.DomainKey
		,concat(d.DomainKey,':',f.fieldname,case when f.FieldName is null then '' else ':' end,p.PermissionKey) ClaimValue
	from security.PermissionAssoc pa
		join security.RolePermissionsAssoc rpa on pa.PermissionAssocId = rpa.PermissionAssocId
		join security.Roles r on rpa.RoleId = r.RoleId
		join security.Domain d on pa.DomainId = d.DomainId
		join security.Permission p on pa.PermissionId = p.PermissionId
		join security.ClaimType ct on pa.ClaimTypeId = ct.ClaimTypeId
		left join security.field f on pa.fieldid = f.FieldId
		left join security.OptionRightsAssoc ora
        on ora.PermissionAssocId = pa.PermissionAssocId
			and ora.PermissionScopeId in (1,2)
	where 
		r.RoleName IN (SELECT RoleName FROM @Roles)
	AND
        (
            -- permission is NOT feature-gated
            pa.IsOptionControlled = 0

            OR

            -- permission is feature-gated AND company has an option that enables it
             EXISTS (
                SELECT 1
                FROM Company.LocationOptionAssoc loa
                    JOIN security.OptionRightsAssoc ora
                        ON loa.OptionId = ora.OptionId
                WHERE
                    loa.CompanyId = @EffectiveCompanyId
                    AND ora.PermissionAssocId = pa.PermissionAssocId
					AND pa.IsOptionControlled = 1
            )
        );
		

END