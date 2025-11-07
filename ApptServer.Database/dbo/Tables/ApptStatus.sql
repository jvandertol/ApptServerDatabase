CREATE TABLE [dbo].[ApptStatus] (
    [ApptStatusId] SMALLINT      IDENTITY (1, 1) NOT NULL,
    [StatusName]   VARCHAR (25)  NOT NULL,
    [SortOrder]    TINYINT       NOT NULL,
    [CreateDtTm]   DATETIME2 (3) NOT NULL,
    [CreatedById]  BIGINT        NOT NULL,
    [UpdateDtTm]   DATETIME2 (3) NULL,
    [UpdatedById]  BIGINT        NULL,
    CONSTRAINT [PK_ApptStatus] PRIMARY KEY CLUSTERED ([ApptStatusId] ASC)
);

