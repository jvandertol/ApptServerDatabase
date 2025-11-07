CREATE TABLE [dbo].[Messages] (
    [Id]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [SendUserName]     NVARCHAR (MAX) NOT NULL,
    [ReceiverUserName] NVARCHAR (MAX) NOT NULL,
    [Text]             NVARCHAR (MAX) NOT NULL,
    [CreatedAt]        DATETIME2 (7)  NOT NULL,
    [UpdatedAt]        DATETIME2 (7)  NOT NULL,
    [IsActive]         BIT            NOT NULL,
    [IsDeleted]        BIT            NOT NULL,
    CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED ([Id] ASC)
);

