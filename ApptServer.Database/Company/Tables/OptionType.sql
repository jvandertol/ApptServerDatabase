CREATE TABLE [Company].[OptionType] (
    [OptionTypeId]   INT           IDENTITY (1, 1) NOT NULL,
    [OptionType]     VARCHAR (25)  NULL,
    [OptionTypeDesc] VARCHAR (150) NULL,
    [CreateDtTm]     DATETIME2 (7) NOT NULL,
    [CreatedById]    BIGINT        NOT NULL,
    [UTCCreateDtTm]  DATETIME2 (7) NOT NULL,
    [UpdateDtTm]     DATETIME2 (7) NULL,
    [UTCUpdateDtTm]  DATETIME2 (7) NULL,
    [UpdateById]     BIGINT        NULL
);

