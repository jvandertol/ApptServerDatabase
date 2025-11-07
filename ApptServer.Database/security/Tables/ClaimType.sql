CREATE TABLE [security].[ClaimType] (
    [ClaimTypeId]   INT           IDENTITY (1, 1) NOT NULL,
    [ClaimTypeKey]  VARCHAR (50)  NOT NULL,
    [ClaimTypeName] VARCHAR (150) NOT NULL,
    [CreateDtTm]    DATETIME2 (3) NOT NULL,
    [CreatedById]   BIGINT        NOT NULL,
    [UpdateDtTm]    DATETIME2 (3) NULL,
    [UpdatedById]   BIGINT        NULL,
    CONSTRAINT [PK_ClaimType] PRIMARY KEY CLUSTERED ([ClaimTypeId] ASC)
);

