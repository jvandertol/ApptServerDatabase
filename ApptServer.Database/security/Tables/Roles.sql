CREATE TABLE [security].[Roles] (
    [RoleId]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [RoleName]         VARCHAR (256)  NOT NULL,
    [IndustryId]       INT            NULL,
    [NormalizedName]   VARCHAR (256)  NOT NULL,
    [RoleDesc]         VARCHAR (2000) NULL,
    [ConcurrencyStamp] VARCHAR (MAX)  NOT NULL,
    [PagingOrder]      INT            NOT NULL,
    [IsDeleted]        BIT            NOT NULL,
    [CreateDtTm]       DATETIME2 (3)  NOT NULL,
    [CreatedById]      BIGINT         NOT NULL,
    [UpdateDtTm]       DATETIME       NULL,
    [UpdatedById]      BIGINT         NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED ([RoleId] ASC)
);

