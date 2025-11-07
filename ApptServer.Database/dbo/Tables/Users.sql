CREATE TABLE [dbo].[Users] (
    [UserId]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [FirstName]            VARCHAR (100)  NULL,
    [LastName]             VARCHAR (100)  NULL,
    [Address]              VARCHAR (2000) NULL,
    [Address2]             VARCHAR (25)   NULL,
    [City]                 VARCHAR (50)   NULL,
    [Region]               VARCHAR (2)    NULL,
    [PoCode]               VARCHAR (15)   NULL,
    [CreatedAt]            DATETIME2 (7)  NOT NULL,
    [UserName]             VARCHAR (256)  NULL,
    [NormalizedUserName]   VARCHAR (256)  NULL,
    [Email]                VARCHAR (256)  NULL,
    [NormalizedEmail]      VARCHAR (256)  NULL,
    [EmailConfirmed]       BIT            NOT NULL,
    [PasswordHash]         VARCHAR (MAX)  NULL,
    [SecurityStamp]        VARCHAR (MAX)  NULL,
    [ConcurrencyStamp]     VARCHAR (MAX)  NULL,
    [PhoneNumber]          VARCHAR (20)   NULL,
    [PhoneNumberConfirmed] BIT            NOT NULL,
    [TwoFactorEnabled]     BIT            NOT NULL,
    [LockoutEnd]           DATETIME2 (7)  NULL,
    [LockoutEnabled]       BIT            NOT NULL,
    [AccessFailedCount]    INT            NOT NULL,
    [IsDeleted]            BIT            NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserId] ASC)
);














GO



GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameEmail]
    ON [dbo].[Users]([Email] ASC, [UserName] ASC);

