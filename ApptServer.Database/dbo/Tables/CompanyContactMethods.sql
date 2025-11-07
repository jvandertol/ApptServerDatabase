CREATE TABLE [dbo].[CompanyContactMethods] (
    [CompanyContactMethodId] BIGINT         NOT NULL,
    [CompanyId]              BIGINT         NOT NULL,
    [ContactMethodValue]     VARCHAR (150)  NOT NULL,
    [ContactMethodTypeId]    SMALLINT       NOT NULL,
    [ContactMehtodPurposeId] SMALLINT       NOT NULL,
    [IsPrimary]              BIT            NOT NULL,
    [Notes]                  VARCHAR (2000) NULL,
    [UTCCreateDtTm]          DATETIME2 (3)  CONSTRAINT [DF_CompanyContactMethods_UTCCreateDtTm] DEFAULT (getutcdate()) NOT NULL,
    CONSTRAINT [PK_CompanyContactMethods] PRIMARY KEY CLUSTERED ([CompanyContactMethodId] ASC)
);

