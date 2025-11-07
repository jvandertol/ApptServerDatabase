CREATE TABLE [security].[Field] (
    [FieldId]     INT           IDENTITY (1, 1) NOT NULL,
    [FieldName]   VARCHAR (25)  NOT NULL,
    [CreateDtTm]  DATETIME2 (3) NOT NULL,
    [CreatedById] BIGINT        NOT NULL,
    [UpdateDtTm]  DATETIME2 (3) NULL,
    [UpdatedById] BIGINT        NULL,
    CONSTRAINT [PK_Field] PRIMARY KEY CLUSTERED ([FieldId] ASC)
);

