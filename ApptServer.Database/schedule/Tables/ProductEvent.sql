CREATE TABLE [schedule].[ProductEvent] (
    [ProductEventId]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [ExternalProductEventId] BIGINT        NULL,
    [CompanyId]              BIGINT        NOT NULL,
    [EnglishName]            VARCHAR (150) NOT NULL,
    [StartDtTm]              DATE          NULL,
    [EndDtTm]                DATE          NULL,
    [ProductEventTypeId]     INT           NOT NULL,
    [IsDeleted]              BIT           NOT NULL,
    [UTCCreateDtTm]          DATETIME2 (3) NOT NULL,
    [UTCUpdateDtTm]          DATETIME2 (3) NULL,
    CONSTRAINT [PK_ProductEvent_4] PRIMARY KEY CLUSTERED ([ProductEventId] ASC)
);

