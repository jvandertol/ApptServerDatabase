CREATE TABLE [dbo].[Roles] (
    [Id]               BIGINT        NOT NULL,
    [Name]             VARCHAR (256) NULL,
    [NormalizedName]   VARCHAR (256) NULL,
    [ConcurrencyStamp] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[Roles]([NormalizedName] ASC) WHERE ([NormalizedName] IS NOT NULL);

