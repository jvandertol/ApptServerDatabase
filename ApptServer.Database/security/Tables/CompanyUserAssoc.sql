CREATE TABLE [security].[CompanyUserAssoc] (
    [CompanyUserAssocId] BIGINT IDENTITY (1, 1) NOT NULL,
    [UserId]             BIGINT NOT NULL,
    [CompanyId]          BIGINT NOT NULL,
    [IsPrimary]          BIT    NOT NULL,
    CONSTRAINT [PK_CompanyUserAssoc] PRIMARY KEY CLUSTERED ([CompanyUserAssocId] ASC)
);

