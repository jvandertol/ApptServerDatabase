CREATE TABLE [dbo].[Appointments] (
    [AppointmentId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [UserId]        BIGINT        NOT NULL,
    [CompanyId]     BIGINT        NOT NULL,
    [PackageId]     BIGINT        NOT NULL,
    [StartDtTm]     DATETIME2 (3) NOT NULL,
    [EndDtTm]       DATETIME2 (3) NOT NULL,
    [ApptStatusId]  SMALLINT      NOT NULL,
    [UTCStartDtTm]  DATETIME2 (3) NOT NULL,
    [UTCEndDtTm]    DATETIME2 (3) NOT NULL,
    [CreateDtTm]    DATETIME2 (3) NOT NULL,
    [UTCCreateDtTm] DATETIME2 (3) NULL,
    [CreateById]    BIGINT        NOT NULL,
    [UpdateDtTm]    DATETIME2 (3) NULL,
    [UTCUpdateDtTm] DATETIME2 (3) NULL,
    [UpdateById]    BIGINT        NULL,
    CONSTRAINT [PK_Appointments] PRIMARY KEY CLUSTERED ([AppointmentId] ASC)
);

