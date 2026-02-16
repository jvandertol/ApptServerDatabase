CREATE TABLE [security].[Users] (
    [UserId]    BIGINT         IDENTITY (1, 1) NOT NULL,
    [FirstName] VARCHAR (100)  NULL,
    [LastName]  VARCHAR (100)  NULL,
    [Address]   VARCHAR (2000) NULL,
    [Address2]  VARCHAR (25)   NULL,
    [City]      VARCHAR (50)   NULL,
    [Region]    VARCHAR (2)    NULL,
    [PoCode]    VARCHAR (15)   NULL,
    [CreatedAt] DATETIME2 (7)  NOT NULL,
    [IsDeleted] BIT            NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC)
);




GO
