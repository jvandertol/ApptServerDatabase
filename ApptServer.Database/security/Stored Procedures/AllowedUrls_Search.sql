CREATE PROCEDURE [security].[AllowedUrls_Search]
@PageNumber int = 0,
@PageId bigint = 1, 
@Forward bit = 1,
@PageSize int =20,
@MaxPages int =3,
@FullList bit = 1,
@Url varchar(250) = NULL


AS BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	-- The stored procedure is not a paged search.  It returns all urls in the table.  The sp is used because search returns a list of items.  Returning all items is a valid search.  


	SET NOCOUNT ON;

	-- Search requires a paging table to be returned
	select 1 PageNumber, 1 FirstId, 1 LastId


	SELECT 
	AllowedURLId Id
	,[Url]
	,CompanyId
	,IsDeleted
	,CreateDtTm
	,CreatedById
	,UpdateDtTm
	,UpdatedById
	 from security.AllowedUrls ;
END