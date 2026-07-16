CREATE TABLE [Company].[CompanyPolicy] (
    [CompanyPolicyId]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [ExternalCompanyPolicyId] BIGINT         NULL,
    [CompanyId]               BIGINT         NOT NULL,
    [PolicyTypeId]            INT            NOT NULL,
    [Policy]                  NVARCHAR (MAX) NULL,
    [CreateDtTm]              DATETIME2 (3)  NOT NULL,
    [CreatedById]             BIGINT         NOT NULL,
    [UpdateDtTm]              DATETIME2 (3)  NULL,
    [UpdatedById]             BIGINT         NULL,
    CONSTRAINT [PK_Policies] PRIMARY KEY CLUSTERED ([CompanyPolicyId] ASC),
    CONSTRAINT [UQ_CompanyPolicy_Company_PolicyType] UNIQUE NONCLUSTERED ([CompanyId] ASC, [PolicyTypeId] ASC)
);

