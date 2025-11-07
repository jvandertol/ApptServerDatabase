CREATE TABLE [security].[FunctionalArea] (
    [FunctionalAreaId]   INT           IDENTITY (1, 1) NOT NULL,
    [FunctionalAreaKey]  VARCHAR (50)  NOT NULL,
    [FunctionalAreaName] VARCHAR (100) NOT NULL,
    [CreateDtTm]         DATETIME2 (3) NOT NULL,
    [CreatedById]        BIGINT        NOT NULL,
    [UpdateDtTm]         DATETIME2 (7) NULL,
    [UpdatedById]        BIGINT        NULL,
    CONSTRAINT [PK_Domains] PRIMARY KEY CLUSTERED ([FunctionalAreaId] ASC)
);

