create PROCEDURE [security].[ActionPermissions_Search_Safe]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@FullList bit = 1,
@DomainKey varchar(50) = NULL,
@Roles security.RoleList READONLY

AS BEGIN
/*
declare @r1 security.RoleList
insert into @r1 values ('SysAdminAPI')

exec [security].[ActionPermissions_Search]  0,1,1,20,3,1,'pkg',@r1

*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- similary to AllowedUrls_Search - the paged list is a stub as the search method expects it

	-- Search requires a paging table to be returned
	select 1 PageNumber, 1 FirstId, 1 LastId

		select 
		pa.PermissionAssocId Id
		,ct.ClaimTypeKey
		,concat(d.DomainKey,':',f.fieldname,case when f.FieldName is null then '' else ':' end,p.PermissionKey) RequiredClaimValue
	from security.PermissionAssoc pa
		join security.RolePermissionsAssoc rpa on pa.PermissionAssocId = rpa.PermissionAssocId
		join security.Roles r on rpa.RoleId = r.RoleId
		join security.Domain d on pa.DomainId = d.DomainId
		join security.Permission p on pa.PermissionId = p.PermissionId
		join security.ClaimType ct on pa.ClaimTypeId = ct.ClaimTypeId
		left join security.field f on pa.fieldid = f.FieldId
	where d.DomainKey = @DomainKey
		AND r.RoleName IN (SELECT RoleName FROM @Roles);

END