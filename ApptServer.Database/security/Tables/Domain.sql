CREATE TABLE [security].[Domain] (
    [DomainId]    INT           IDENTITY (1, 1) NOT NULL,
    [DomainKey]   VARCHAR (50)  NOT NULL,
    [DomainName]  VARCHAR (100) NOT NULL,
    [CreateDtTm]  DATETIME2 (3) NOT NULL,
    [CreatedById] BIGINT        NOT NULL,
    [UpdateDtTm]  DATETIME2 (3) NULL,
    [UpdateById]  BIGINT        NULL,
    CONSTRAINT [PK_Domain] PRIMARY KEY CLUSTERED ([DomainId] ASC)
);

