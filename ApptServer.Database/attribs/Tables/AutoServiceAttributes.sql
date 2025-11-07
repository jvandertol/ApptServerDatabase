CREATE TABLE [attribs].[AutoServiceAttributes] (
    [AutoServiceAttribId]    INT           IDENTITY (1, 1) NOT NULL,
    [CompanyId]              BIGINT        NOT NULL,
    [LicenseNumber]          VARCHAR (25)  NULL,
    [AutoServiceLicenseFlag] INT           NULL,
    [CreateDtTm]             DATETIME2 (3) NOT NULL,
    [CreatedById]            BIGINT        NOT NULL,
    [UpdateDtTm]             DATETIME2 (3) NULL,
    [UpdatedById]            BIGINT        NULL,
    CONSTRAINT [PK_AutoServiceAttributes] PRIMARY KEY CLUSTERED ([AutoServiceAttribId] ASC)
);

