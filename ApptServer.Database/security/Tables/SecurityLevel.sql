CREATE TABLE [security].[SecurityLevel] (
    [SecurityLevelId]        INT           IDENTITY (1, 1) NOT NULL,
    [SecurityLevelName]      VARCHAR (100) NOT NULL,
    [RequiresAuthentication] BIT           NOT NULL,
    [CreateDtTm]             DATETIME2 (3) NOT NULL,
    [CreatedById]            BIGINT        NOT NULL,
    [UpdateDtTm]             DATETIME2 (3) NULL,
    [UpdateById]             BIGINT        NULL,
    CONSTRAINT [PK_SecurityLevel] PRIMARY KEY CLUSTERED ([SecurityLevelId] ASC)
);

