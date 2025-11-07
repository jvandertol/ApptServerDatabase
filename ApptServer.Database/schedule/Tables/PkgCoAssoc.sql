CREATE TABLE [schedule].[PkgCoAssoc] (
    [PkgCoAssocId]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [PackageId]         BIGINT        NOT NULL,
    [ExternalPackageId] BIGINT        NOT NULL,
    [CreateDtTm]        DATETIME2 (3) NOT NULL,
    [CreateById]        BIGINT        NOT NULL,
    [UpdateDtTm]        DATETIME2 (3) NULL,
    [UpdateById]        BIGINT        NULL,
    CONSTRAINT [PK_PkgCoAssoc] PRIMARY KEY CLUSTERED ([PkgCoAssocId] ASC)
);

