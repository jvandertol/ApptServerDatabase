CREATE PROCEDURE [dbo].[Users_Set]
	@UserId	bigint	= NULL
	,@FirstName	varchar(250)= NULL
	,@LastName	varchar(250)= NULL
	,@Address	varchar(250)= NULL
	,@Address2	varchar(25)= NULL
	,@City	varchar(50)= NULL
	,@Region	varchar(2)= NULL
	,@PoCode	varchar(15)= NULL
	,@UserName	varchar(256) = NULL
	--,@NormalizedUserName	varchar(256)
	,@Email	varchar(256)
	--,@NormalizedEmail	varchar(256)
	,@EmailConfirmed	bit	= NULL
	,@Password	varchar(max) = NULL
	,@SecurityStamp	varchar(max)= NULL
	,@ConcurrencyStamp	varchar(max)= NULL
	,@MobilePhone	varchar(50)= NULL
	,@PhoneNumberConfirmed	bit	= NULL
	,@TwoFactorEnabled	bit	= NULL
	,@LockoutEnd	datetimeoffset	= NULL
	,@LockoutEnabled	bit	= NULL
	,@AccessFailedCount	int	= NULL
	,@IsDeleted bit = 0
	,@Origin varchar(200)
AS
BEGIN TRY

/*
	exec users_set @Email = 'bo@boo.com', @Origin = 'https://localhost:7222' -- duplicate user by email
	exec users_set @Email = '123@boo.com', @MobilePhone='9999999999', @Origin = 'https://localhost:7222' -- duplicate user by phone

	exec users_set @UserId=99999, @Email = 'bo@boo.com', @Origin = 'https://localhost:7222' -- non existant user
	
*/

	declare @updated bit = 0

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @CompanyId bigint

	select @CompanyId = CompanyId from security.AllowedURLs where url = @Origin

	if(@UserId is null) begin
		-- Insert statements for procedure here
		INSERT INTO [dbo].[users] (
			FirstName, LastName, [Address], [Address2], [City], [Region], [PoCode], CreatedAt,
			UserName, Email, EmailConfirmed, PasswordHash, SecurityStamp, ConcurrencyStamp, PhoneNumber,
			PhoneNumberConfirmed, TwoFactorEnabled, LockoutEnd, LockoutEnabled, AccessFailedCount, IsDeleted
		)
		SELECT
			v.FirstName,
			v.LastName,
			v.Address,
			v.Address2,
			v.City,
			v.Region,
			v.PoCode,
			GETUTCDATE(),
			ISNULL(v.UserName, v.Email),
			v.Email,
			0,
			v.Password,
			v.SecurityStamp,
			v.ConcurrencyStamp,
			v.PhoneNumber,
			0,
			0,
			NULL,
			0,
			0,
			0
		FROM (
			SELECT
				@FirstName AS FirstName,
				@LastName AS LastName,
				@Address AS Address,
				@Address2 AS Address2,
				@City AS City,
				@Region AS Region,
				@PoCode AS PoCode,
				@UserName AS UserName,
				@Email AS Email,
				@Password AS Password,
				@SecurityStamp AS SecurityStamp,
				@ConcurrencyStamp AS ConcurrencyStamp,
				@MobilePhone AS PhoneNumber
		) AS v
		LEFT JOIN [dbo].[users] u
			ON u.Email = @Email OR (u.PhoneNumber = @MobilePhone and @MobilePhone is not null)
		WHERE u.UserId IS NULL;


		select @UserId = SCOPE_IDENTITY()

		IF @UserId IS NULL
		BEGIN
			THROW 50001, 'SQLERROR-50001 - Insert failed: a user with this email or phone number already exists.', 1;
		END

		insert into security.CompanyUserAssoc values (@UserId, @CompanyId)

	end
	else begin
    -- Insert statements for procedure here
		update [dbo].[users] set
			 FirstName			= case when @FirstName is null then FirstName else @FirstName end
			,LastName			= case when @LastName is null then LastName else @LastName end
			,[Address]			= case when @Address is null then Address else @Address end
			,Address2			= case when @Address2 is null then Address2 else @Address2 end
			,City				= case when @City is null then City else @City end
			,Region				= case when @Region is null then Region else @Region end
			,PoCode				= case when @PoCode is null then PoCode else @PoCode end
			,Email				= case when @Email is null then Email else @Email end
			,EmailConfirmed		= case when @EmailConfirmed is null then EmailConfirmed else @EmailConfirmed end	
			,PasswordHash		= case when @Password is null then PasswordHash else @Password end
			,SecurityStamp		= case when @SecurityStamp is null then SecurityStamp else @SecurityStamp end
			,ConcurrencyStamp	= case when @ConcurrencyStamp is null then ConcurrencyStamp else @ConcurrencyStamp end
			,PhoneNumber		= case when @MobilePhone is null then PhoneNumber else @MobilePhone end
			,PhoneNumberConfirmed= case when @PhoneNumberConfirmed is null then PhoneNumberConfirmed else @PhoneNumberConfirmed end
			,TwoFactorEnabled	= case when @TwoFactorEnabled is null then TwoFactorEnabled else @TwoFactorEnabled end
			,LockoutEnd			= case when @LockoutEnd is null then LockoutEnd else @LockoutEnd end
			,LockoutEnabled		= case when @LockoutEnabled is null then LockoutEnabled else @LockoutEnabled end
			,AccessFailedCount  = case when @AccessFailedCount is null then AccessFailedCount else @AccessFailedCount end
			,IsDeleted			= case when @IsDeleted is null then IsDeleted else @IsDeleted end
		where UserId = @UserId
		
		IF @@ROWCOUNT = 0
		BEGIN
			THROW 50002, 'SQLERROR-50002 - Update failed: no user found with the specified UserId.', 1;
		END

	end

	select @UserId

END TRY
BEGIN CATCH
 DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    -- Get the error details
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    -- Rollback the transaction if it's still open
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
    END

    -- Log the error or raise it
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH