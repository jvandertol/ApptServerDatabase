CREATE TABLE [schedule].[VehicleTypes] (
    [VehicleTypeId] INT          IDENTITY (1, 1) NOT NULL,
    [VehicleTypeCd] VARCHAR (10) NOT NULL,
    [Icon]          VARCHAR (25) NOT NULL,
    [Name]          VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_VehicleIcons] PRIMARY KEY CLUSTERED ([VehicleTypeId] ASC)
);

