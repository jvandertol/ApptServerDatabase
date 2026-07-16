CREATE TABLE [Company].[PolicyType] (
    [PolicyTypeId] INT          IDENTITY (1, 1) NOT NULL,
    [IndustryId]   INT          NULL,
    [PolicyName]   VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_PolicyType] PRIMARY KEY CLUSTERED ([PolicyTypeId] ASC)
);

