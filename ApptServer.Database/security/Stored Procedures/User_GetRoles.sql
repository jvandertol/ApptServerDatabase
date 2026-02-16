-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	This returns all the roles for a specific user.  Used for maintenance and insertion into JWT
-- =============================================
CREATE PROCEDURE [security].[User_GetRoles]
@UserId bigint
AS BEGIN 
	SET NOCOUNT ON
	select r.RoleName from security.Roles r
		join security.UserRolesAssoc ura on r.RoleId = ura.RoleId
	where ura.CompanyUserAssocId = @UserId

END