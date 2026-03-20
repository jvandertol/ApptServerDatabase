CREATE PROCEDURE [security].[Users_Search]
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
,@Origin varchar(200) = null
,@CompanyId bigint = null
,@AllowedCaller varchar(15) = null

AS BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if(@Origin is null and @CompanyId is null and @AllowedCaller is null)
		THROW 50002, 'Origin or CompanyId is required.', 1;

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
		,CompanyId bigint NULL
	)

		if isnull(@Forward,1) = 1 begin
			insert into #tmpU
			select top (@pagesize) 
				cas.UserId
				,u.FirstName
				,u.LastName
				,u.[Address]
				,cas.UserName
				,cas.PasswordHash
				,cas.Email
				,cas.PhoneNumber
				,cas.TwoFactorEnabled
				,cas.LockoutEnd
				,cas.LockoutEnabled
				,cas.AccessFailedCount
				,cas.IsDeleted
				,cas.CompanyId
			from security.Users u
				join (
					select ca.CompanyUserAssocId UserId, ca.UserId u2, ca.CompanyId, ca.UserName, ca.PasswordHash,ca.Email,ca.EmailConfirmed,
						ca.PhoneNumber, ca.TwoFactorEnabled, ca.LockoutEnd,ca.LockoutEnabled,ca.IsDeleted,ca.AccessFailedCount
					from security.CompanyUserAssoc ca
					where ca.isPrimary = 1
					  and (
							(@CompanyId IS NOT NULL AND ca.CompanyId = @CompanyId)
						 OR (@CompanyId IS NULL
							 AND EXISTS (
								 select 1
								 from security.AllowedURLs ar
								 where ar.CompanyId = ca.CompanyId
								   and ar.Url = @Origin
							 )
						 )
					  )
				  OR (
						@AllowedCaller = 'escwebservice'
						AND ca.CompanyId = -1
				  )

				) cas on u.UserId = cas.u2
				where 
					u.UserId >= @PageId and
					(Firstname = @Firstname OR @Firstname IS NULL) AND
					(LastName = @LastName OR @LastName IS NULL) AND
					(Address = @Address OR @Address IS NULL) AND
					(cas.UserName = @UserName OR @UserName IS NULL) AND
					(cas.PasswordHash = @Password OR @Password IS NULL) AND
					(cas.Email = @Email OR @Email IS NULL) AND
					(cas.EmailConfirmed = @EmailConfirmed OR @EmailConfirmed IS NULL) AND
					(cas.PhoneNumber = @PhoneNumber OR @PhoneNumber IS NULL) AND
					(cas.TwoFactorEnabled = @TwoFactorEnabled OR @TwoFactorEnabled IS NULL) AND
					(cas.LockoutEnd = @LockoutEnd OR @LockoutEnd IS NULL) AND
					(cas.LockoutEnabled = @LockoutEnabled OR @LockoutEnabled IS NULL) AND
					(cas.isDeleted = @IsDeleted) and
					(cas.AccessFailedCount = @AccessFailedCount OR @AccessFailedCount IS NULL);
		end
		else begin
			insert into #tmpU
			select top (@pagesize) 
				cas.UserId
				,u.FirstName
				,u.LastName
				,u.[Address]
				,cas.UserName
				,cas.PasswordHash
				,cas.Email
				,cas.PhoneNumber
				,cas.TwoFactorEnabled
				,cas.LockoutEnd
				,cas.LockoutEnabled
				,cas.AccessFailedCount
				,cas.IsDeleted
				,cas.CompanyId
			from security.users u
				join (
					select ca.CompanyUserAssocId UserId, ca.UserId u2, ca.CompanyId, ca.UserName, ca.PasswordHash,ca.Email,ca.EmailConfirmed,
						ca.PhoneNumber, ca.TwoFactorEnabled, ca.LockoutEnd,ca.LockoutEnabled,ca.IsDeleted,ca.AccessFailedCount
					from security.CompanyUserAssoc ca
					where ca.isPrimary = 1
					  and (
							(@CompanyId IS NOT NULL AND ca.CompanyId = @CompanyId)
						 OR (@CompanyId IS NULL
							 AND EXISTS (
								 select 1
								 from security.AllowedURLs ar
								 where ar.CompanyId = ca.CompanyId
								   and ar.Url = @Origin
							 )
						 )
					  )
					  OR (
						@AllowedCaller = 'escwebservice'
						AND ca.CompanyId = -1
					)
				) cas on u.UserId = cas.u2
				where 
					u.UserId < @PageId and
					(Firstname = @Firstname OR @Firstname IS NULL) AND
					(LastName = @LastName OR @LastName IS NULL) AND
					(Address = @Address OR @Address IS NULL) AND
					(cas.UserName = @UserName OR @UserName IS NULL) AND
					(cas.PasswordHash = @Password OR @Password IS NULL) AND
					(cas.Email = @Email OR @Email IS NULL) AND
					(cas.EmailConfirmed = @EmailConfirmed OR @EmailConfirmed IS NULL) AND
					(cas.PhoneNumber = @PhoneNumber OR @PhoneNumber IS NULL) AND
					(cas.TwoFactorEnabled = @TwoFactorEnabled OR @TwoFactorEnabled IS NULL) AND
					(cas.LockoutEnd = @LockoutEnd OR @LockoutEnd IS NULL) AND
					(cas.LockoutEnabled = @LockoutEnabled OR @LockoutEnabled IS NULL) AND
					(cas.isDeleted = @IsDeleted) and
					(cas.AccessFailedCount = @AccessFailedCount OR @AccessFailedCount IS NULL);
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