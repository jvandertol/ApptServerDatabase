CREATE TABLE [schedule].[VehTypeCoAssoc] (
    [VehTypeCoAssocId] BIGINT IDENTITY (1, 1) NOT NULL,
    [CompanyId]        BIGINT NOT NULL,
    [VehicleTypeId]    INT    NOT NULL,
    CONSTRAINT [PK_VehTypeCoAssoc] PRIMARY KEY CLUSTERED ([VehTypeCoAssocId] ASC)
);

