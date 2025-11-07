CREATE TABLE [security].[AllowedURLs] (
    [AllowedURLId] INT           IDENTITY (1, 1) NOT NULL,
    [Url]          VARCHAR (250) NOT NULL,
    [CompanyId]    BIGINT        NOT NULL,
    [IsDeleted]    BIT           NOT NULL,
    [CreateDtTm]   DATETIME2 (3) NOT NULL,
    [CreatedById]  BIGINT        NOT NULL,
    [UpdateDtTm]   DATETIME2 (3) NULL,
    [UpdatedById]  BIGINT        NULL,
    CONSTRAINT [PK_AllowedURLs] PRIMARY KEY CLUSTERED ([AllowedURLId] ASC)
);

