CREATE TABLE [dbo].[Logs] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [UserName]    NVARCHAR (MAX) NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [CreatedAt]   DATETIME2 (7)  NOT NULL,
    [UpdatedAt]   DATETIME2 (7)  NOT NULL,
    [IsActive]    BIT            NOT NULL,
    [IsDeleted]   BIT            NOT NULL,
    CONSTRAINT [PK_Logs] PRIMARY KEY CLUSTERED ([Id] ASC)
);

