CREATE TABLE [schedule].[YearTypes] (
    [YearTypeId]  INT           IDENTITY (1, 1) NOT NULL,
    [YearType]    VARCHAR (50)  NOT NULL,
    [CreateDtTm]  DATETIME2 (3) NOT NULL,
    [CreatedById] BIGINT        NOT NULL,
    [UpdateDtTm]  DATETIME2 (3) NULL,
    [UpdatedById] BIGINT        NULL,
    CONSTRAINT [PK_YearTypes] PRIMARY KEY CLUSTERED ([YearTypeId] ASC)
);

