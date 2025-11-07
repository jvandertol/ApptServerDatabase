CREATE TABLE [schedule].[DOWEventType] (
    [id]            INT            IDENTITY (1, 1) NOT NULL,
    [eventName]     VARCHAR (25)   NOT NULL,
    [eventDesc]     VARCHAR (2000) NULL,
    [CreateDtTm]    DATETIME2 (7)  NULL,
    [CreatedById]   BIGINT         NULL,
    [UpdateDtTm]    DATETIME2 (7)  NULL,
    [UpdatedById]   BIGINT         NULL,
    [UTCCreateDtTm] DATETIME2 (7)  NULL,
    [UTCUpdateDtTm] DATETIME2 (7)  NULL
);

