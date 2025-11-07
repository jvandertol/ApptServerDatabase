CREATE TABLE [dbo].[RoleClaims] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [RoleId]     BIGINT        NOT NULL,
    [ClaimType]  VARCHAR (MAX) NULL,
    [ClaimValue] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_RoleClaims] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RoleClaims_Roles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles] ([Id]) ON DELETE CASCADE
);




GO
CREATE NONCLUSTERED INDEX [IX_RoleClaims_RoleId]
    ON [dbo].[RoleClaims]([RoleId] ASC);

