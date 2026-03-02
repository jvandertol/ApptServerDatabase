CREATE TABLE [security].[OptionRightsAssoc] (
    [OptionRightsAssocId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [OptionId]            BIGINT        NOT NULL,
    [PermissionAssocId]   BIGINT        NOT NULL,
    [PermissionScopeId]   TINYINT       NOT NULL,
    [CreateDtTm]          DATETIME2 (3) NOT NULL,
    [CreateUserId]        BIGINT        NOT NULL,
    [UpdateDtTm]          DATETIME2 (3) NULL,
    [UpdateUserId]        BIGINT        NULL,
    CONSTRAINT [PK_OptionRightsAssoc] PRIMARY KEY CLUSTERED ([OptionRightsAssocId] ASC)
);

