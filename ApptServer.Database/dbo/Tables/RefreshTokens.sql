CREATE TABLE [dbo].[RefreshTokens] (
    [UserId]       BIGINT        NOT NULL,
    [RefreshToken] VARCHAR (MAX) NOT NULL,
    [IssuedAt]     DATETIME2 (3) NOT NULL,
    [ExpiresAt]    DATETIME2 (3) NOT NULL,
    [IsRevoked]    BIT           NULL,
    [RevokedAt]    DATETIME2 (3) NULL,
    CONSTRAINT [PK_RefreshTokens_1] PRIMARY KEY CLUSTERED ([UserId] ASC)
);

