CREATE TABLE [security].[UserRolesAssoc] (
    [UserRolesAssocId]   BIGINT IDENTITY (1, 1) NOT NULL,
    [RoleId]             BIGINT NOT NULL,
    [CompanyUserAssocId] BIGINT NOT NULL,
    CONSTRAINT [PK_UserRolesAssoc] PRIMARY KEY CLUSTERED ([UserRolesAssocId] ASC)
);

