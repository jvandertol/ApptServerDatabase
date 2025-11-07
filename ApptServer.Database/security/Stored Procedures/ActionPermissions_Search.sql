CREATE PROCEDURE [security].[ActionPermissions_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@FullList bit = 1,
@DomainKey varchar(50) = NULL


AS BEGIN
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
		join security.Domain d on pa.DomainId = d.DomainId
		join security.Permission p on pa.PermissionId = p.PermissionId
		join security.ClaimType ct on pa.ClaimTypeId = ct.ClaimTypeId
		left join security.field f on pa.fieldid = f.FieldId
	where d.DomainKey = @DomainKey
END