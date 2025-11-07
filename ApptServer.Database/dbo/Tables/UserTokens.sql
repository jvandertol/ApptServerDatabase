CREATE TABLE [dbo].[UserTokens] (
    [UserId]        BIGINT        NOT NULL,
    [LoginProvider] VARCHAR (450) NOT NULL,
    [Name]          VARCHAR (450) NOT NULL,
    [Value]         VARCHAR (MAX) NULL,
    CONSTRAINT [PK_UserTokens] PRIMARY KEY CLUSTERED ([UserId] ASC)
);

