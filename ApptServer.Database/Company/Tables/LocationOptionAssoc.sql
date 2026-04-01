CREATE TABLE [Company].[LocationOptionAssoc] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [OptionId]         VARCHAR (150) NOT NULL,
    [CompanyId]        BIGINT        NOT NULL,
    [UTCEffectiveDate] DATETIME2 (0) NOT NULL,
    [PropertyXml]      XML           NULL,
    [OverrideCost]     MONEY         NULL,
    [UTCCreateDtTm]    DATETIME      NOT NULL,
    [CreateId]         BIGINT        NOT NULL,
    [UTCUpdateDtTm]    DATETIME      NULL,
    [UpdateId]         BIGINT        NULL,
    CONSTRAINT [PK_LocationOptionAssoc] PRIMARY KEY CLUSTERED ([Id] ASC)
);

