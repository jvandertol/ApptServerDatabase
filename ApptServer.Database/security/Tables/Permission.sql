CREATE TABLE [security].[Permission] (
    [PermissionId]   INT           IDENTITY (1, 1) NOT NULL,
    [PermissionKey]  VARCHAR (50)  NOT NULL,
    [PermissionName] VARCHAR (50)  NULL,
    [Description]    VARCHAR (200) NULL,
    [PagingOrder]    INT           NOT NULL,
    [IsDeleted]      BIT           NOT NULL,
    [CreateDtTm]     DATETIME2 (3) NOT NULL,
    [CreatedById]    BIGINT        NOT NULL,
    [UpdateDtTm]     DATETIME2 (3) NULL,
    [UpdateById]     BIGINT        NULL,
    CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED ([PermissionId] ASC)
);

