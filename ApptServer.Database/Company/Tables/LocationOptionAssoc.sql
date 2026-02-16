CREATE TABLE [Company].[LocationOptionAssoc] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [OptionId]      VARCHAR (150) NOT NULL,
    [CompanyId]     BIGINT        NOT NULL,
    [EffectiveDate] DATETIME2 (0) NOT NULL,
    [PropertyXml]   XML           NULL,
    [OverrideCost]  MONEY         NULL,
    CONSTRAINT [PK_LocationOptionAssoc] PRIMARY KEY CLUSTERED ([Id] ASC)
);

