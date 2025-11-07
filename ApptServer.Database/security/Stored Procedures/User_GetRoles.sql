CREATE PROCEDURE [security].[User_GetRoles]
@UserId bigint
AS BEGIN TRY
	select r.RoleName from security.Roles r
		join security.UserRolesAssoc ura on r.RoleId = ura.RoleId
	where ura.UserId = @UserId

END TRY
BEGIN CATCH
        -- Optionally log error here
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Re-throw the original exception (preserves number, severity, state)
        THROW;
END CATCH