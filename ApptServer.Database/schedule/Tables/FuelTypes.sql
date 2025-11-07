CREATE TABLE [schedule].[FuelTypes] (
    [FuelTypeId] INT          IDENTITY (1, 1) NOT NULL,
    [FuelTypeCd] VARCHAR (10) NOT NULL,
    [Name]       VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_FuelTypes] PRIMARY KEY CLUSTERED ([FuelTypeId] ASC)
);

