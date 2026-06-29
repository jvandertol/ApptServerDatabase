CREATE TABLE [Company].[LocationOptionAssocLog] (
    [LogId]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [Id]               BIGINT        NOT NULL,
    [OptionId]         VARCHAR (150) NOT NULL,
    [CompanyId]        BIGINT        NOT NULL,
    [UTCEffectiveDate] DATETIME2 (0) NOT NULL,
    [PropertyXml]      XML           NULL,
    [OverrideCost]     MONEY         NULL,
    [UTCCreateDtTm]    DATETIME      NOT NULL,
    [CreateId]         BIGINT        NOT NULL,
    [UTCUpdateDtTm]    DATETIME      NULL,
    [UpdateId]         BIGINT        NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_LocationOptionAssocLog]
    ON [Company].[LocationOptionAssocLog]([LogId] ASC);

