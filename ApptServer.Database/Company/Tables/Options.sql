CREATE TABLE [Company].[Options] (
    [Id]                       INT            IDENTITY (1, 1) NOT NULL,
    [OptionName]               VARCHAR (150)  NOT NULL,
    [OptionDescription]        VARCHAR (2000) NULL,
    [IndustryId]               INT            NULL,
    [ExternalOptionId]         INT            NULL,
    [PropertyXml]              XML            NULL,
    [OptionTypeId]             INT            NULL,
    [Cost]                     MONEY          NULL,
    [SubscriptionInterval]     INT            NULL,
    [SubscriptionIntervalUnit] INT            NULL,
    [IsActive]                 BIT            NULL,
    [IsVisible]                BIT            NULL,
    [OptionPlanId]             INT            NULL,
    [SortOrder]                INT            NULL,
    [CreateDtTm]               DATETIME2 (0)  NULL,
    [CreateUserId]             BIGINT         NULL,
    [UpdateCreateDtTm]         DATETIME2 (7)  NULL,
    [UpdateUserId]             BIGINT         NULL,
    [OptionGroupId]            INT            NULL,
    CONSTRAINT [PK_Options] PRIMARY KEY CLUSTERED ([Id] ASC)
);

