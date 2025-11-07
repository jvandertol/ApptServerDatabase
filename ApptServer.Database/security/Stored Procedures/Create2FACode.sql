CREATE PROCEDURE [security].[Create2FACode]
@AuthCode int 
,@FirstName varchar(50)
,@LastName varchar(50)
,@AuthContactValue varchar(150)
,@AuthContactMethodId bigint 
,@MinutesToExpire tinyint
,@origin varchar(250)
,@ResultCode smallint OUTPUT -- 1 = success not registered, -- 2 = success already registered, -1 error of some kind

/*
-- user found no jwt
declare @ResultCode smallint
exec [security].[Create2FACode] '654322','123@boo.com', 2, 2, 'https://localhost:5176', @ResultCode output
select @ResultCode

-- user found jtw found 
declare @ResultCode smallint
exec [security].[Create2FACode] '123456','bo@boo.com', 2, 2, 'https://localhost:5176', @ResultCode output
select @ResultCode

-- no user found
declare @ResultCode smallint
exec [security].[Create2FACode] '654322','nouser@boo.com', 2, 2, 'https://localhost:5176', @ResultCode output
select @ResultCode



select * from users
*/

AS BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @authcodefound bit = 0
	,@UserId bigint
	,@CompanyId bigint --get from origin

	-- if the request is coming from a login page - any existing refresh tokens should be deleted.  This will logout any other computer

	-- Case one - returns ValidLoggedIn(0) - user is already logged in from this machine/browser.  Web service checks for user authorized. 
	-- Case oneA- returns InvalidLoggedIn(1) user is already logged in from a different machine/browser.  If an unexpired JWT Refresh token is found.  User should be asked to close other session. select user where companyid = @CompanyId and @AuthContactValue = user.email left join on dbo.RefreshToken (move to security schema)
	
	------------------ user is not logged in if logic gets here
	-- Case two - A one-time password request as the user is an existing user -  select user where companyid = @CompanyId and @AuthContactValue = user.email left join on dbo.RefreshToken r (move to security schema) and r.UserId is null
	-- Case three - No user exists for the email and company - new registration

	-- For case two and three gen TwoFactorCode - it is possible that one already exists, if so, delete it and make a new one.
	-- Case one no 2FA code exists for email that is not expired.  Create a 2FA code
	-- Case two a 2FA code exists for email that is not expired and @RefreshToken is 1.  Delete existing code and Create a new 2FA code
	-- Case three a 2FA code exists for email that is not expired and @RefreshToken is 0.  This is an error

	-- get company from origin
	select @CompanyId = a.CompanyId from security.AllowedURLs a where a.Url = @origin

	-- does the user exist
	if @AuthContactMethodId = 1 begin -- phone

		select @UserId = u.UserId from Users u 
			join security.CompanyUserAssoc cua on u.UserId = u.UserId and cua.Companyid = @Companyid
		where u.PhoneNumber = @AuthContactValue 
	end
	else begin
		--select @UserId = u.UserId from Users u 
		--	join security.CompanyUserAssoc cua on u.UserId = cua.UserId and cua.Companyid = @Companyid
		--	where Email = @AuthContactValue 
		declare @namesmatch bit
		select @UserId = u.UserId, @namesmatch= isnull(u2.UserId, 0)  from Users u 
					join security.CompanyUserAssoc cua on u.UserId = cua.UserId and cua.Companyid = 1
					left join 
					(
					select userid from users u1 where u1.FirstName = @FirstName and u1.LastName = @LastName

					) u2 on u.UserId = u2.UserId
		where Email = @AuthContactValue
	end

	-- valid email, different names
	if(@namesmatch = 0 and @UserId is not null) begin
		select @ResultCode = 4
		return 
	end

	-- if a user is found check if there is a valud JWT refresh token for the userid, if so user logged into another machine/browser revoke the refresh token
	if(@UserId is not null) begin
	-- this code will let client know,  Current implementation don't tell client, just log them out by revoking refresh token
		--if Exists(select 1 from RefreshTokens r where r.UserId = @UserId and r.IsRevoked <> 1 and r.ExpiresAt > GETUTCDATE()) begin
		--	select @ResultCode = 1	  
		--	return
		--end

		-- if there is a refresh token revoke it, if none found this will do nothing
		update RefreshTokens 
			set IsRevoked =1
			,RevokedAt = GETUTCDATE()
		where 
		UserId = @UserId and IsRevoked <> 1 and ExpiresAt > GETUTCDATE()

	end

-- User is either null or not logged in anywhere. Gen 2FA code

	-- delete any 2FA codes for the user and company but may have an existing 2FA code
	delete from security.TwoFactorCode where AuthContactValue = @AuthContactValue 
		and CompanyId = @CompanyId

	insert into security.TwoFactorCode values (
		@UserId  
		,@AuthCode
		,@CompanyId
		,@AuthContactValue
		,@AuthContactMethodId 
		,GETUTCDATE()
		,1
		,@MinutesToExpire
		)
	select @ResultCode = 2

END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorNumber INT;

    -- Capture the error message and error number
    SET @ErrorMessage = ERROR_MESSAGE();
    SET @ErrorNumber = ERROR_NUMBER();

    -- Optionally, you can re-throw the error if needed
    THROW;  --

END CATCH