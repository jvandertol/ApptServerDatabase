CREATE TABLE [security].[RolePermissionsAssoc] (
    [RolePermissionsAssocId] INT IDENTITY (1, 1) NOT NULL,
    [RoleId]                 INT NOT NULL,
    [PermissionAssocId]      INT NOT NULL,
    CONSTRAINT [PK_RolPermissionsAssoc] PRIMARY KEY CLUSTERED ([RolePermissionsAssocId] ASC)
);

