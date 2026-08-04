CREATE PROCEDURE [security].[Users_Set]
   @CompanyUserAssocId bigint = null
--	@UserId	bigint	= NULL
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
	,@RoleName varchar(50)
	,@CompanyId bigint NULL = NULL
	,@AllowedCaller varchar(25) = NULL
AS
BEGIN


/*
	exec users_set @Email = 'bo@boo.com', @Origin = 'https://localhost:7222' -- duplicate user by email
	exec users_set @Email = '123@boo.com', @MobilePhone='9999999999', @Origin = 'https://localhost:7222' -- duplicate user by phone

	exec users_set @UserId=99999, @Email = 'bo@boo.com', @Origin = 'https://localhost:7222' -- non existant user
	
*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @UserId bigint

	if @CompanyId is null begin
		select @CompanyId = CompanyId from security.AllowedURLs where url = @Origin
	end

	-- need to add sql error
	if @CompanyId is null begin
			throw 50001, 'SQLERROR-50001 - Company could not be determined.', 1;
	end

	-- check if a user with a matching email exists
	if(@CompanyUserAssocId is null) begin
		select top 1 @UserId = u.UserId from security.CompanyUserAssoc u
				where u.Email = @Email
		-- support phone later
		--			   or (cua.PhoneNumber = @MobilePhone and @MobilePhone is not null);
	end
	else begin
		select @UserId = u.UserId from security.CompanyUserAssoc u
				where CompanyUserAssocId = @CompanyUserAssocId
	end

	select @CompanyUserAssocId = CompanyUserAssocId  from security.CompanyUserAssoc where UserId = @UserId and CompanyId = @CompanyId and @CompanyUserAssocId is null


	if(@UserId is null) begin

		-- Insert statements for procedure here
		INSERT INTO [security].[users] (
			FirstName, LastName, [Address], [Address2], [City], [Region], [PoCode], CreatedAt, IsDeleted
		)
		values (
			@FirstName,
			@LastName,
			@Address,
			@Address2,
			@City,
			@Region,
			@PoCode,
			GETUTCDATE(),
			0
		);
		
		select @UserId = SCOPE_IDENTITY()
	end

	if(@CompanyUserAssocId is null ) begin
		insert into security.CompanyUserAssoc values (
			@UserId 
			,@CompanyId
			,1			-- IsPrimary
			,case when @UserName is null then @Email end
			,@Email
			,@EmailConfirmed
			,@Password
			,@MobilePhone
			,@PhoneNumberConfirmed
			,@TwoFactorEnabled
			,@LockoutEnd
			,@LockoutEnabled
			,@AccessFailedCount
			,@IsDeleted
		)

		select @CompanyUserAssocId = SCOPE_IDENTITY()

		-- add role
		insert into security.UserRolesAssoc
		  select roleid, @CompanyUserAssocId from security.Roles where RoleName = @RoleName

	end
	else begin
    -- Insert statements for procedure here
		update u
		set
			 FirstName			= case when @FirstName is null then FirstName else @FirstName end
			,LastName			= case when @LastName is null then LastName else @LastName end
			,[Address]			= case when @Address is null then Address else @Address end
			,Address2			= case when @Address2 is null then Address2 else @Address2 end
			,City				= case when @City is null then City else @City end
			,Region				= case when @Region is null then Region else @Region end
			,PoCode				= case when @PoCode is null then PoCode else @PoCode end
			,IsDeleted			= case when @IsDeleted is null then u.IsDeleted else @IsDeleted end
		from security.users u
			join security.companyuserassoc cua on u.UserId = cua.UserId
		where cua.CompanyUserAssocId = @CompanyUserAssocId
		
		IF @@ROWCOUNT = 0
		BEGIN
			THROW 50002, 'SQLERROR-50002 - Update failed: no user found with the specified UserId.', 1;
		END

		update security.companyuserassoc
		set
			CompanyId					= @CompanyId		
			,IsPrimary					= 1
			,PasswordHash				= @Password
			,TwoFactorEnabled 			= case when @TwoFactorEnabled is null then TwoFactorEnabled else @TwoFactorEnabled end
			,LockoutEnd 				= case when @LockoutEnd is null then LockoutEnd else @LockoutEnd end
			,LockoutEnabled				= case when @LockoutEnabled is null then LockoutEnabled else @LockoutEnabled end
			,AccessFailedCount			= case when @AccessFailedCount is null then AccessFailedCount else @AccessFailedCount end
			,IsDeleted					= case when @IsDeleted is null then IsDeleted else @IsDeleted end
		where CompanyUserAssocId = @CompanyUserAssocId and CompanyId = @CompanyId

	end

	select @CompanyUserAssocId


END