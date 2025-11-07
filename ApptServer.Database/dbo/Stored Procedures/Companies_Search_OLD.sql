CREATE PROCEDURE [dbo].[Companies_Search_OLD]
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@CompanyName varchar(200) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tmpC (
		[CompanyId] [bigint]  NOT NULL,
		[CompanyName] [varchar](100) NOT NULL,
		[Street1] [varchar](200) NOT NULL,
		[Street2] [varchar](25) NULL,
		[City] [varchar](200) NOT NULL,
		[RegionCd] [varchar](2) NOT NULL,
		[PoCode] [varchar](10) NOT NULL,
		[PrimaryPhone] [varchar](15) NOT NULL,
		[PrimaryEmail] [varchar](100) NULL,
		[IsDeleted] [bit] NOT NULL
	)


	if @Forward = 1 begin
		insert into #tmpC
		select top (@pagesize*@MaxPages) 
			*
		from companies 
			where 
			CompanyId > @PageId
			and (CompanyName like '%' + @CompanyName + '%' or @CompanyName is null);
	end
	else begin
		insert into #tmpC
		select top (@pagesize*@MaxPages) 
			*
		from companies 
			where 
			CompanyId < @PageId
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
		MIN(CompanyId) AS FirstId,
		MAX(CompanyId) AS LastId
	FROM 
		NumberedRows
	GROUP BY 
		(RowNum - 1) / @pagesize
	ORDER BY 
		FirstId;

    -- Insert statements for procedure here
	SELECT 
	top (@PageSize)
	CompanyId Id
	,CompanyName Name
	,Street1
	,Street2
	,City
	,RegionCd [State]
	,PoCode
	,PrimaryPhone
	,PrimaryEmail
	,IsDeleted
	 from #tmpC

END