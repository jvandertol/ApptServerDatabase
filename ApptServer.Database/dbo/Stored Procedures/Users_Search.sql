CREATE PROCEDURE [dbo].[Users_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@FirstName varchar(100) = null
,@LastName varchar(100) = null
,@Address varchar(2000) = null
,@UserName	varchar(256) = null
,@Password varchar(250) = null
,@Email	varchar(256) = null
,@EmailConfirmed	bit = null
,@SecurityStamp	varchar(max) = null
,@ConcurrencyStamp	varchar(max) = null
,@PhoneNumber	varchar(20) = null
,@TwoFactorEnabled	bit = null
,@LockoutEnd	datetime2(0) = NULL
,@LockoutEnabled	bit	= NULL
,@AccessFailedCount	int	= NULL
,@IsDeleted bit = 0
,@Origin varchar(200)

AS BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tmpU (
		UserId bigint,
		FirstName varchar(100) null
		,LastName varchar(100) null
		,Address varchar(2000) null
		,UserName	varchar(256)
		,PasswordHash varchar(max)
		,Email	varchar(256)
		,PhoneNumber	varchar(20) null
		,TwoFactorEnabled	bit null
		,LockoutEnd	datetime2(0)	NULL
		,LockoutEnabled	bit	NULL
		,AccessFailedCount	int	NULL
		,IsDeleted bit 
		,CompanyId bigint
	)

		if isnull(@Forward,1) = 1 begin
			insert into #tmpU
			select top (@pagesize) 
				u.UserId
				,u.FirstName
				,u.LastName
				,u.[Address]
				,u.UserName
				,u.PasswordHash
				,u.Email
				,u.PhoneNumber
				,u.TwoFactorEnabled
				,u.LockoutEnd
				,u.LockoutEnabled
				,u.AccessFailedCount
				,u.IsDeleted
				,cas.CompanyId
			from Users u
				join 
				(
					select UserId,ar.CompanyId from security.CompanyUserAssoc ca 
						join security.AllowedURLs ar on ca.CompanyId = ar.CompanyId
						where ar.Url = isnull(@Origin,'-1')
							and ca.isPrimary = 1
				) cas on u.UserId = cas.UserId
				where 
					u.UserId >= @PageId and
					(Firstname = @Firstname OR @Firstname IS NULL) AND
					(LastName = @LastName OR @LastName IS NULL) AND
					(Address = @Address OR @Address IS NULL) AND
					(UserName = @UserName OR @UserName IS NULL) AND
					(PasswordHash = @Password OR @Password IS NULL) AND
					(Email = @Email OR @Email IS NULL) AND
					(EmailConfirmed = @EmailConfirmed OR @EmailConfirmed IS NULL) AND
					(SecurityStamp = @SecurityStamp OR @SecurityStamp IS NULL) AND
					(ConcurrencyStamp = @ConcurrencyStamp OR @ConcurrencyStamp IS NULL) AND
					(PhoneNumber = @PhoneNumber OR @PhoneNumber IS NULL) AND
					(TwoFactorEnabled = @TwoFactorEnabled OR @TwoFactorEnabled IS NULL) AND
					(LockoutEnd = @LockoutEnd OR @LockoutEnd IS NULL) AND
					(LockoutEnabled = @LockoutEnabled OR @LockoutEnabled IS NULL) AND
					(isDeleted = @IsDeleted) and
					(AccessFailedCount = @AccessFailedCount OR @AccessFailedCount IS NULL);
		end
		else begin
			insert into #tmpU
			select top (@pagesize) 
				u.UserId
				,u.FirstName
				,u.LastName
				,u.[Address]
				,u.UserName
				,u.PasswordHash
				,u.Email
				,u.PhoneNumber
				,u.TwoFactorEnabled
				,u.LockoutEnd
				,u.LockoutEnabled
				,u.AccessFailedCount
				,u.IsDeleted
				,cas.CompanyId
			from users u
				join 
					(
					select UserId,ar.CompanyId from security.CompanyUserAssoc ca 
							join security.AllowedURLs ar on ca.CompanyId = ar.CompanyId 
						where ar.Url = isnull(@Origin,'-1')
								and ca.isPrimary = 1
					) cas on u.UserId = cas.UserId
				where 
					u.UserId < @PageId and
					(u.Firstname = @Firstname OR @Firstname IS NULL) AND
					(u.LastName = @LastName OR @LastName IS NULL) AND
					(u.[Address] = @Address OR @Address IS NULL) AND
					(u.UserName = @UserName OR @UserName IS NULL) AND
					(u.PasswordHash = @Password OR @Password IS NULL) AND
					(u.Email = @Email OR @Email IS NULL) AND
					(u.EmailConfirmed = @EmailConfirmed OR @EmailConfirmed IS NULL) AND
					(u.SecurityStamp = @SecurityStamp OR @SecurityStamp IS NULL) AND
					(u.ConcurrencyStamp = @ConcurrencyStamp OR @ConcurrencyStamp IS NULL) AND
					(u.PhoneNumber = @PhoneNumber OR @PhoneNumber IS NULL) AND
					(u.TwoFactorEnabled = @TwoFactorEnabled OR @TwoFactorEnabled IS NULL) AND
					(u.LockoutEnd = @LockoutEnd OR @LockoutEnd IS NULL) AND
					(u.LockoutEnabled = @LockoutEnabled OR @LockoutEnabled IS NULL) AND
					(u.isDeleted = @IsDeleted) and
					(u.AccessFailedCount = @AccessFailedCount OR @AccessFailedCount IS NULL);
		end
		;
		
		WITH NumberedRows AS (
			SELECT 
				*,
				ROW_NUMBER() OVER (ORDER BY UserId) AS RowNum
			FROM 
				#tmpU
		)
		SELECT 
			(ROW_NUMBER() OVER (ORDER BY (RowNum - 1) / @PageSize) - 1) / 1 + 1 + @PageNumber AS PageNumber,  -- Calculate page number with @PageNumber
			MIN(UserId) AS FirstId,                                                                -- Return the minimum CompanyId for that page
			MAX(UserId) AS LastId
		FROM 
			NumberedRows
		GROUP BY 
			(RowNum - 1) / @PageSize                                                                         -- Group by calculated page number
		ORDER BY 
			PageNumber;                                                                                       -- Order by page number

--	end

 --   -- Insert statements for procedure here
	SELECT 
	--top (@PageSize)
		UserId Id
		,FirstName
		,LastName
		,[Address]
		,UserName
		,PasswordHash
		,Email
		,PhoneNumber
		,TwoFactorEnabled
		,LockoutEnd
		,LockoutEnabled
		,AccessFailedCount
		,IsDeleted
		,CompanyId
	from #tmpU

END