CREATE TABLE [dbo].[UserLogins] (
    [LoginProvider]       NVARCHAR (450) NOT NULL,
    [ProviderKey]         NVARCHAR (450) NOT NULL,
    [ProviderDisplayName] NVARCHAR (MAX) NULL,
    [UserId]              BIGINT         NOT NULL,
    CONSTRAINT [PK_UserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC)
);




GO
CREATE NONCLUSTERED INDEX [IX_UserLogins_UserId]
    ON [dbo].[UserLogins]([UserId] ASC);

