CREATE TABLE [security].[PermissionsScope] (
    [PermissionsScopeId]  TINYINT      IDENTITY (1, 1) NOT NULL,
    [PermissionScopeName] VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_PermissionsScope] PRIMARY KEY CLUSTERED ([PermissionsScopeId] ASC)
);

