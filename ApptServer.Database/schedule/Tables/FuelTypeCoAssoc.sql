CREATE TABLE [schedule].[FuelTypeCoAssoc] (
    [FuelTypeCoAssocId] BIGINT IDENTITY (1, 1) NOT NULL,
    [CompanyId]         BIGINT NOT NULL,
    [FuelTypeId]        INT    NOT NULL,
    CONSTRAINT [PK_FuelTypeCoAssoc] PRIMARY KEY CLUSTERED ([FuelTypeCoAssocId] ASC)
);

