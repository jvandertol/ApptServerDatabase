CREATE TABLE [attribs].[AutoSvcPkgAttribAssoc] (
    [AutoSvcPkgAttribAssocId] BIGINT        NOT NULL,
    [PackageId]               BIGINT        NOT NULL,
    [AttributeId]             INT           NOT NULL,
    [CreateDtTm]              DATETIME2 (3) NOT NULL,
    [CreateById]              BIGINT        NOT NULL,
    [UpdateDtTm]              DATETIME2 (3) NULL,
    [UpdateById]              BIGINT        NULL,
    CONSTRAINT [PK_AutoSvcPkgAttrib] PRIMARY KEY CLUSTERED ([AutoSvcPkgAttribAssocId] ASC)
);

