-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [security].[GetUserPermissions]
	@Id bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	/*
	exec [security].[GetUserPermissions] 1
	*/

	SET NOCOUNT ON;

	select 
		pa.PermissionAssocId Id
		,ct.ClaimTypeKey
		,concat(d.DomainKey,':',f.fieldname,case when f.FieldName is null then '' else ':' end,p.PermissionKey) ClaimValue
	from security.PermissionAssoc pa
		join security.Domain d on pa.DomainId = d.DomainId
		join security.Permission p on pa.PermissionId = p.PermissionId
		join security.ClaimType ct on pa.ClaimTypeId = ct.ClaimTypeId
		join security.RolePermissionsAssoc rpa on pa.PermissionAssocId = rpa.PermissionAssocId
		join security.UserRolesAssoc ura on rpa.RoleId = ura.RoleId
		left join security.field f on pa.fieldid = f.FieldId
	where ura.UserId = @Id

END