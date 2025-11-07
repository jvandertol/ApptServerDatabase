CREATE TABLE [schedule].[ServiceTypePkgAssoc] (
    [ServiceTypePkgAssocId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [PackageId]             BIGINT        NOT NULL,
    [ServiceTypeId]         INT           NOT NULL,
    [UTCCreateDtTm]         DATETIME2 (3) NOT NULL,
    [UTCUpdateDtTm]         DATETIME2 (3) NULL,
    CONSTRAINT [PK_ServiceTypePkgAssoc] PRIMARY KEY CLUSTERED ([ServiceTypePkgAssocId] ASC)
);

