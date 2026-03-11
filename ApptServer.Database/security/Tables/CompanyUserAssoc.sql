CREATE TABLE [security].[CompanyUserAssoc] (
    [CompanyUserAssocId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [UserId]               BIGINT        NOT NULL,
    [CompanyId]            BIGINT        NOT NULL,
    [IsPrimary]            BIT           NOT NULL,
    [UserName]             VARCHAR (256) NOT NULL,
    [Email]                VARCHAR (256) NULL,
    [EmailConfirmed]       BIT           NULL,
    [PasswordHash]         VARCHAR (MAX) NULL,
    [PhoneNumber]          VARCHAR (20)  NULL,
    [PhoneNumberConfirmed] BIT           NULL,
    [TwoFactorEnabled]     BIT           NULL,
    [LockoutEnd]           DATETIME2 (3) NULL,
    [LockoutEnabled]       BIT           NULL,
    [AccessFailedCount]    INT           NULL,
    [IsDeleted]            BIT           NOT NULL,
    CONSTRAINT [PK_CompanyUserAssoc] PRIMARY KEY CLUSTERED ([CompanyUserAssocId] ASC)
);

