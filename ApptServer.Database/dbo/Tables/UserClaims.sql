CREATE TABLE [dbo].[UserClaims] (
    [Id]         INT           IDENTITY (1, 1) NOT NULL,
    [UserId]     BIGINT        NOT NULL,
    [ClaimType]  VARCHAR (MAX) NULL,
    [ClaimValue] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_UserClaims] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_UserClaims_UserId]
    ON [dbo].[UserClaims]([UserId] ASC);

