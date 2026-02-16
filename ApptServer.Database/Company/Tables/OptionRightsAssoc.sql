CREATE TABLE [Company].[OptionRightsAssoc] (
    [OptionRightsAssocId] BIGINT        NOT NULL,
    [OptionId]            BIGINT        NOT NULL,
    [PermissionId]        BIGINT        NOT NULL,
    [CreateDtTm]          DATETIME2 (3) NOT NULL,
    [CreateUserId]        BIGINT        NOT NULL,
    [UpdateDtTm]          DATETIME2 (3) NULL,
    [UpdateUserId]        BIGINT        NULL,
    CONSTRAINT [PK_OptionRightsAssoc] PRIMARY KEY CLUSTERED ([OptionRightsAssocId] ASC)
);

