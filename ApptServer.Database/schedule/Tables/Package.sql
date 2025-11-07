CREATE TABLE [schedule].[Package] (
    [PackageId]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [PackageName]     VARCHAR (200) NOT NULL,
    [SinglePriceFlag] BIT           NOT NULL,
    [CompanyId]       BIGINT        NOT NULL,
    [PackageXml]      XML           NULL,
    [EstDurationMins] INT           NULL,
    [ShowPriceOnline] BIT           NULL,
    [Price]           MONEY         NULL,
    CONSTRAINT [PK_Package] PRIMARY KEY CLUSTERED ([PackageId] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Package_Company_PackageName]
    ON [schedule].[Package]([CompanyId] ASC, [PackageName] ASC);

