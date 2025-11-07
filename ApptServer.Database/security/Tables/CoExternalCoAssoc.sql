CREATE TABLE [security].[CoExternalCoAssoc] (
    [CoExternalCoAssocId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [CompanyId]           BIGINT        NOT NULL,
    [ExternalCompanyId]   BIGINT        NOT NULL,
    [CreateDtTm]          DATETIME2 (3) NOT NULL,
    [CreatedById]         BIGINT        NOT NULL,
    [UpdateDtTm]          DATETIME2 (3) NULL,
    [UpdateById]          BIGINT        NULL,
    CONSTRAINT [PK_CoExternalCoAssoc] PRIMARY KEY CLUSTERED ([CoExternalCoAssocId] ASC)
);

