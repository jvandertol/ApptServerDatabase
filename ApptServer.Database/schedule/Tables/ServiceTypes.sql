CREATE TABLE [schedule].[ServiceTypes] (
    [ServiceTypeId] INT           IDENTITY (1, 1) NOT NULL,
    [ServiceName]   VARCHAR (200) NOT NULL,
    [IndustryId]    INT           NOT NULL,
    [IsDeleted]     BIT           NOT NULL,
    [UTCCreateDtTm] DATETIME2 (3) NOT NULL,
    [UTCUpdateDtTm] DATETIME2 (3) NULL,
    CONSTRAINT [PK_ServiceTypes] PRIMARY KEY CLUSTERED ([ServiceTypeId] ASC)
);

