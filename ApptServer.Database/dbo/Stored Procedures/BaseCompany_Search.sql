CREATE PROCEDURE [dbo].[BaseCompany_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@CompanyName varchar(200) = NULL

AS BEGIN
/*
	exec [dbo].[Companies_Search] @PageNumber =null, @PageId =0,@Forward = null, @PageSize =20,@MaxPages =3, @CompanyName ='m'
*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	select @Forward = isnull(@Forward,1)

	CREATE TABLE #tmpC (
		[CompanyId] [bigint]  NOT NULL,
		[CompanyName] [varchar](100) NOT NULL,
		[ARD] [varchar](10) not null,
		CAAutoServiceLicenseFlag int not null,
		[Street1] [varchar](200) NOT NULL,
		[Street2] [varchar](25) NULL,
		[City] [varchar](200) NOT NULL,
		[RegionCd] [varchar](2) NOT NULL,
		[PoCode] [varchar](10) NOT NULL,
		[PrimaryPhone] [varchar](15) NOT NULL,
		[PrimaryEmail] [varchar](100) NULL,
		[ApptPolicy] [varchar](100) NOT NULL,
		[UseDST] [bit] not null,
		[TimeZone] [varchar](50) not null,
		[IsDeleted] [bit] NOT NULL,
		BusinessType varchar(25) not null,
		UTCCreateDtTm DateTime2(3) NOT NULL,
		UTCUpdateDtTm DateTime2(3) NULL
	)

/*
Commented on 2025-03-20 as the parameter is defaulted to 1, so this code should not be executed
*/

	--if @Forward is null begin
	--	insert into #tmpC
	--		select top (@pagesize) 
	--			*
	--		from companies 
	--			where 
	--			CompanyId >= @PageId
	--			and (CompanyName like '%' + @CompanyName + '%' or @CompanyName is null);
	--			--select @PageNumber PageNumber, @PageId FirstId, @PageId LastId;

	--			WITH NumberedRows AS (
	--		SELECT 
	--			CompanyId,
	--			ROW_NUMBER() OVER (ORDER BY CompanyId) AS RowNum
	--		FROM 
	--			#tmpC
	--	)
	--	SELECT 
	--		@PageNumber AS PageNumber,  
	--		MIN(CompanyId) AS FirstId,                                                                -- Return the minimum CompanyId for that page
	--		MAX(CompanyId) AS LastId
	--	FROM 
	--		NumberedRows
	--	GROUP BY 
	--		(RowNum - 1) / @PageSize                                                                         -- Group by calculated page number
	--	ORDER BY 
	--		PageNumber;      
	--end
	--else begin
		if @Forward = 1 begin
			insert into #tmpC
			select top (@pagesize*@MaxPages) 
				c.CompanyId Id
				,CompanyName Name
				,asa.LicenseNumber ARD
				,asa.AutoServiceLicenseFlag CAAutoServiceLicenseFlag
				,Street1
				,Street2
				,City
				,RegionCd [State]
				,PoCode
				,PrimaryPhone
				,PrimaryEmail
				,ApptPolicy
				,[UseDST]
				,TimeZone
				,IsDeleted
				,BusinessType
				,UTCCreateDtTm
				,UTCUpdateDtTm
				from dbo.companies c
			join attribs.AutoServiceAttributes asa on c.CompanyId = asa.CompanyId
				where 
				c.CompanyId >= @PageId
				and (CompanyName like '%' + @CompanyName + '%' or @CompanyName is null);
		end
		else begin
			insert into #tmpC
			select top (@pagesize*@MaxPages) 
				*
			from companies 
				where 
				CompanyId <= @PageId
				and (CompanyName like '%' + @CompanyName + '%' or @CompanyName is null);
		end
		;
		
		WITH NumberedRows AS (
			SELECT 
				CompanyId,
				ROW_NUMBER() OVER (ORDER BY CompanyId) AS RowNum
			FROM 
				#tmpC
		)
		SELECT 
			(ROW_NUMBER() OVER (ORDER BY (RowNum - 1) / @PageSize) - 1) / 1 + 1 + @PageNumber AS PageNumber,  -- Calculate page number with @PageNumber
			MIN(CompanyId) AS FirstId,                                                                -- Return the minimum CompanyId for that page
			MAX(CompanyId) AS LastId
		FROM 
			NumberedRows
		GROUP BY 
			(RowNum - 1) / @PageSize                                                                         -- Group by calculated page number
		ORDER BY 
			PageNumber;                                                                                       -- Order by page number

--	end

    -- Insert statements for procedure here
	SELECT 
	--top (@PageSize)
		CompanyId Id
		,CompanyName Name
		,ARD
		,CAAutoServiceLicenseFlag
		,Street1
		,Street2
		,City
		,RegionCd [State]
		,PoCode
		,PrimaryPhone
		,PrimaryEmail
		,ApptPolicy
		,[UseDST]
		,TimeZone
		,IsDeleted
		,BusinessType
		,UTCCreateDtTm
		,UTCUpdateDtTm
	 from #tmpC
END