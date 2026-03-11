CREATE PROCEDURE [dbo].[Companies_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@Name varchar(200) = NULL,
@Street1 varchar(50) = null,
@City varchar(50) = null,
@state varchar(50) = null,
@PoCode varchar(50) = null,
@PrimaryPhone varchar(50) = null,
@PrimaryEmail varchar(50) = null,
@BusinessType varchar(25)


AS BEGIN
/*
	exec [dbo].[Companies_Search] @PageNumber =null, @PageId =0,@Forward = null, @PageSize =20,@MaxPages =3, @CompanyName ='m', @BusinessType = 'caautoserviceshop'
*/

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @BusinessType = 'caautoserviceshop'
		EXEC CAAutoServiceShop_Search @PageNumber, @PageId, @Forward, @PageSize, @MaxPages,@Name
	ELSE
		EXEC BaseCompany_Search  @PageNumber, @PageId, @Forward, @PageSize, @MaxPages,@Name
END