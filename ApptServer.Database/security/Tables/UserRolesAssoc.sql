CREATE TABLE [security].[UserRolesAssoc] (
    [UserRolesAssocId] BIGINT IDENTITY (1, 1) NOT NULL,
    [UserId]           BIGINT NOT NULL,
    [RoleId]           BIGINT NOT NULL,
    CONSTRAINT [PK_UserRolesAssoc] PRIMARY KEY CLUSTERED ([UserRolesAssocId] ASC)
);

