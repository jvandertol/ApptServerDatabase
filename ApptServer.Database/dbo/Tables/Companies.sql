CREATE TABLE [dbo].[Companies] (
    [CompanyId]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [CompanyName]   VARCHAR (100)  NOT NULL,
    [Street1]       VARCHAR (200)  NOT NULL,
    [Street2]       VARCHAR (25)   NULL,
    [City]          VARCHAR (200)  NOT NULL,
    [RegionCd]      VARCHAR (2)    NOT NULL,
    [PoCode]        VARCHAR (10)   NOT NULL,
    [PrimaryPhone]  VARCHAR (15)   NOT NULL,
    [PrimaryEmail]  VARCHAR (100)  NULL,
    [ApptPolicy]    VARCHAR (3000) NOT NULL,
    [UseDST]        BIT            NOT NULL,
    [TimeZone]      VARCHAR (50)   NOT NULL,
    [IsDeleted]     BIT            NOT NULL,
    [BusinessType]  VARCHAR (25)   NULL,
    [UTCCreateDtTm] DATETIME2 (3)  NOT NULL,
    [UTCUpdateDtTm] DATETIME2 (3)  NULL,
    CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED ([CompanyId] ASC)
);








GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Companies_CompanyAddress]
    ON [dbo].[Companies]([CompanyName] ASC, [Street1] ASC, [City] ASC, [RegionCd] ASC, [PoCode] ASC);

