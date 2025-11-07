CREATE TABLE [security].[TwoFactorCode] (
    [TwoFactorCodeId]     INT           IDENTITY (1, 1) NOT NULL,
    [UserId]              BIGINT        NULL,
    [AuthCode]            INT           NOT NULL,
    [CompanyId]           BIGINT        NULL,
    [AuthContactValue]    VARCHAR (150) NOT NULL,
    [AuthContactMethodId] INT           NOT NULL,
    [CreateDtTm]          DATETIME2 (3) NOT NULL,
    [CreatedById]         BIGINT        NOT NULL,
    [MinutesToExpired]    INT           NOT NULL,
    CONSTRAINT [PK_AuthCode] PRIMARY KEY CLUSTERED ([TwoFactorCodeId] ASC)
);






GO
CREATE NONCLUSTERED INDEX [IDX_AuthCode_UserId]
    ON [security].[TwoFactorCode]([AuthCode] ASC, [UserId] ASC);

