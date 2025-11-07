CREATE PROCEDURE [dbo].[Companies_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@CompanyName varchar(200) = NULL,
@BusinessType varchar(25)


AS BEGIN
/*
	exec [dbo].[Companies_Search] @PageNumber =null, @PageId =0,@Forward = null, @PageSize =20,@MaxPages =3, @CompanyName ='m', @BusinessType = 'caautoserviceshop'
*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @BusinessType = 'caautoserviceshop'
		EXEC CAAutoServiceShop_Search @PageNumber, @PageId, @Forward, @PageSize, @MaxPages,@CompanyName
	ELSE
		EXEC BaseCompany_Search  @PageNumber, @PageId, @Forward, @PageSize, @MaxPages,@CompanyName
END