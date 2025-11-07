CREATE TABLE [search].[CASearchAttribute] (
    [CASearchAttributeId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [CompanyId]             BIGINT        NOT NULL,
    [ARD]                   VARCHAR (15)  NOT NULL,
    [CompanyName]           VARCHAR (150) NOT NULL,
    [PrimaryPhone]          VARCHAR (15)  NOT NULL,
    [PrimaryEmail]          VARCHAR (150) NULL,
    [CityName]              VARCHAR (50)  NOT NULL,
    [RegionCd]              VARCHAR (2)   NOT NULL,
    [PoCode]                VARCHAR (25)  NOT NULL,
    [IsEmissionInspector]   BIT           NOT NULL,
    [IsAutoRepair]          BIT           NOT NULL,
    [IsSafetyInspector]     BIT           NOT NULL,
    [IsCleanTruckInspector] BIT           NOT NULL,
    [CreateDtTm]            DATETIME2 (3) NOT NULL,
    [CreateById]            BIGINT        NOT NULL,
    [UpdateDtTm]            DATETIME2 (3) NULL,
    [UpdateById]            BINARY (50)   NULL,
    CONSTRAINT [PK_CASearchAttribute] PRIMARY KEY CLUSTERED ([CASearchAttributeId] ASC)
);

