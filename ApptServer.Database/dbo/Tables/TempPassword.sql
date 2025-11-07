CREATE TABLE [dbo].[TempPassword] (
    [TempPasswordId] INT           IDENTITY (1, 1) NOT NULL,
    [Password]       VARCHAR (10)  NOT NULL,
    [ExpiryDtTm]     DATETIME2 (3) NOT NULL,
    [UTCExpiryDtTm]  DATETIME2 (3) NOT NULL,
    [CreateDtTm]     DATETIME2 (3) NOT NULL,
    [CreateById]     BIGINT        NOT NULL,
    CONSTRAINT [PK_TempPassword] PRIMARY KEY CLUSTERED ([TempPasswordId] ASC)
);

