CREATE TABLE [schedule].[YearTypeCoAssoc] (
    [YearTypeCoAssocId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [YearTypeId]        INT           NOT NULL,
    [CompanyId]         BIGINT        NOT NULL,
    [CreateDtTm]        DATETIME2 (3) NOT NULL,
    [CreatedById]       BIGINT        NOT NULL,
    [UpdateDtTm]        DATETIME2 (3) NULL,
    [UpdatedById]       BIGINT        NULL,
    CONSTRAINT [PK_YearTypeCoAssoc] PRIMARY KEY CLUSTERED ([YearTypeCoAssocId] ASC)
);

