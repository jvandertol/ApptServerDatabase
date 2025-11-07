CREATE TABLE [metadata].[PkgAttributes] (
    [PkgAttributeId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [AttributeName]  VARCHAR (100) NOT NULL,
    [CreateDtTm]     DATETIME2 (3) NOT NULL,
    [CreateById]     BIGINT        NOT NULL,
    [UpdateDtTm]     DATETIME2 (3) NULL,
    [UpdateById]     BIGINT        NULL,
    CONSTRAINT [PK_PkgAttributes] PRIMARY KEY CLUSTERED ([PkgAttributeId] ASC)
);

