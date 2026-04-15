-- =============================================
-- Author:			JTV
-- Create date:		2026-03-27
-- Description:		returns a list of claims in the form of:
-- Scope:			(either 1 or 2) for Actor or Company enumeration
-- ClaimTypeKey:	such as acc-perm of fld-perm
-- RoleName:		Customer, Admin, etc
-- DomainName:		Domain the claim operates on
-- ClaimValue:		Combination of short domain:claim value
-- Description:		The claim value is referenced by the object code where permissions are required.  if the claimvalue is found the action is allowed.
--					The scope is used to identify who the claim is acting on.  1 = Actor or the current user, 2 is a company level claim.  This permission is granted
--					when a company has selected a particular option or feature as part of their account subscription
-- =============================================

CREATE PROCEDURE [security].[ActionPermissions_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@CompanyId bigint,
@Roles security.RoleList READONLY

AS BEGIN
/*
declare @r1 security.RoleList
insert into @r1 values ('CUSTOMER')

exec [security].[ActionPermissions_Search]  0,1,1,20,3,1,@r1

*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- similary to AllowedUrls_Search - the paged list is a stub as the search method expects it

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
                    loa.CompanyId = @CompanyId
                    AND ora.PermissionAssocId = pa.PermissionAssocId
					AND pa.IsOptionControlled = 1
            )
        );
		

END