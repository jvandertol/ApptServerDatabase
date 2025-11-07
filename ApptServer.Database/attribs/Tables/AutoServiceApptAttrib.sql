CREATE TABLE [attribs].[AutoServiceApptAttrib] (
    [AutoServiceApptAttribId] INT          IDENTITY (1, 1) NOT NULL,
    [AppointmentId]           BIGINT       NOT NULL,
    [VehicleId]               BIGINT       NULL,
    [YearTypeId]              SMALLINT     NULL,
    [VehicleTypeCd]           VARCHAR (10) NULL,
    [FuelTypeCd]              VARCHAR (10) NULL,
    CONSTRAINT [PK_AutoServiceApptAttrib] PRIMARY KEY CLUSTERED ([AutoServiceApptAttribId] ASC)
);

