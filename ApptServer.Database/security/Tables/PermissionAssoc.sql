CREATE TABLE [security].[PermissionAssoc] (
    [PermissionAssocId] INT           IDENTITY (1, 1) NOT NULL,
    [ClaimTypeId]       INT           NULL,
    [DomainId]          INT           NOT NULL,
    [FieldId]           INT           NULL,
    [PermissionId]      INT           NOT NULL,
    [CreateDtTm]        DATETIME2 (3) NOT NULL,
    [CreatedById]       BIGINT        NOT NULL,
    [UpdateDtTm]        DATETIME2 (3) NULL,
    [UpdatedById]       BIGINT        NULL,
    CONSTRAINT [PK_PermissionAssoc] PRIMARY KEY CLUSTERED ([PermissionAssocId] ASC)
);

