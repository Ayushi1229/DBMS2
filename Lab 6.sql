CREATE TABLE Products ( 
Product_id INT PRIMARY KEY, 
Product_Name VARCHAR(250) NOT NULL, 
Price DECIMAL(10, 2) NOT NULL 
); 
--  Insert data into the Products table 
INSERT INTO Products (Product_id, Product_Name, Price) VALUES 
(1, 'Smartphone', 35000), 
(2, 'Laptop', 65000), 
(3, 'Headphones', 5500), 
(4, 'Television', 854000), 
(5, 'Gaming Console', 32000);

SELECT * FROM Products

--Part - A 
--1. Create a cursor Product_Cursor to fetch all the rows from a products table. 
DECLARE @Product_id INT , @Product_Name VARCHAR(250), @Price DECIMAL(10,2)

Declare Product_Cursor Cursor
FOR
	SELECT Product_id,Product_Name,Price FROM Products
open Product_cursor
fetch next from Product_Cursor into @Product_id, @Product_Name, @Price
while @@FETCH_STATUS=0
	begin
		SELECT @Product_id AS Product_id,@Product_Name AS Product_Name,@Price AS Price
		FETCH NEXT FROM Product_Cursor INTO @Product_id,@Product_Name,@Price
	END
close Product_Cursor
deallocate Product_Cursor
--2. Create a cursor Product_Cursor_Fetch to fetch the records in form of ProductID_ProductName. 
--(Example: 1_Smartphone) 
DECLARE @Product_id INT,@Product_Name VARCHAR(250),@Msg VARCHAR(200)
DECLARE Product_Cursor_Fetch CURSOR
For
	select 
		CAST(Product_id as varchar) + ' ' + Product_Name as ProductInfo
		from Products
open Product_Cursor_Fetch
declare @ProductInfo varchar(300)
fetch next from Product_Cursor_Fetch into @ProductInfo
while @@FETCH_STATUS=0
Begin
	print @ProductInfo
	fetch next from Product_Cursor_Fetch into @ProductInfo
End
close Product_Cursor_Fetch
deallocate Product_Cursor_Fetch
--3. Create a Cursor to Find and Display Products Above Price 30,000. 
DECLARE @Product_Name VARCHAR(250),@Price DECIMAL(10,2)
DECLARE Product_Cursor_Price CURSOR
For
	Select Product_Name,Price from Products
open Product_Cursor_Price 
fetch next from Product_Cursor_Price into @Product_Name,@Price
while @@FETCH_STATUS=0
	begin
		if @Price>30000
		select @Product_Name,@Price
		fetch next from Product_Cursor_Price into @Product_Name,@Price
	end
close Product_Cursor_Price
deallocate Product_Cursor_Price
--4. Create a cursor Product_CursorDelete that deletes all the data from the Products table. 
DECLARE @Product_id INT,@Product_Name VARCHAR(250),@Price decimal(10,2)
DECLARE Product_CursorDelete CURSOR
for 
	select Product_id,Product_Name,Price from Products
open Product_CursorDelete
fetch next from Product_CursorDelete into @Product_id,@Product_Name,@Price
while @@FETCH_STATUS=0
	begin
		DELETE FROM Products WHERE Product_id=@Product_id
		FETCH NEXT FROM Product_CursorDelete INTO @Product_id,@Product_Name,@Price
	END
close Product_CursorDelete
deallocate Product_CursorDelete

--Part – B 
--5. Create a cursor Product_CursorUpdate that retrieves all the data from the products table and increases 
--the price by 10%. 
declare @ProductID int, @Price decimal(10,8)
declare Product_CursorUpdate Cursor
for select
	Product_id,
	Price from Products
open Product_CursorUpdate
fetch next from Product_CursorUpdate into @ProductID, @Price
while @@FETCH_STATUS=0
begin
	update Products Set Price = Price*1.10
	where Product_id=@ProductID
	fetch next from Product_CursorUpdate into @ProductID,@Price
end
close Product_CursorUpdate
deallocate Product_CursorUpdate
--6. Create a Cursor to Rounds the price of each product to the nearest whole number.
DECLARE @Product_id INT, @Price DECIMAL(10,2)

DECLARE product_cursor CURSOR
for
	select Product_id,price 
	from Products
open product_cursor
fetch next from product_cursor into @Product_id,@Price
while @@FETCH_STATUS=0
	begin
		update price
		SET Price = ROUND(@Price, 0) 
		WHERE Product_id = @Product_id
	fetch next from product_cursor into @Product_id, @Price
	end
close product_cursor
deallocate product_cursor

select * from Products

--Part – C 
--7. Create a cursor to insert details of Products into the NewProducts table if the product is “Laptop” 
--(Note: Create NewProducts table first with same fields as Products table) 
CREATE TABLE  NewProducts( 
Product_id INT PRIMARY KEY, 
Product_Name VARCHAR(250) NOT NULL, 
Price DECIMAL(10, 2) NOT NULL 
); 
DECLARE @Product_id INT,@Product_Name VARCHAR(250),@Price decimal(10,2)
DECLARE Product_CursorInsert CURSOR
for
	select Product_id,Product_Name,Price from Products
open Product_CursorInsert
fetch next from Product_CursorInsert into @Product_id, @Product_Name, @Price
while @@FETCH_STATUS=0
	begin
		if @Product_Name='Laptop'
		Insert into NewProducts values(@Product_id,@Product_Name,@Price)
		fetch next from Product_CursorInsert into @Product_id,@Product_Name, @Price
	end
close Product_CursorInsert
deallocate Product_CursorInsert
--8. Create a Cursor to Archive High-Price Products in a New Table (ArchivedProducts), Moves products 
--with a price above 50000 to an archive table, removing them from the original Products table. 
CREATE TABLE ArchivedProducts
(Product_id INT PRIMARY KEY,
 Product_Name VARCHAR(250) NOT NULL,
 Price DECIMAL(10, 2) NOT NULL
 )
DECLARE @ProductID INT,@ProductName VARCHAR(250),@Price INT
DECLARE ArchivedProducts_CURSOR CURSOR
for
	select Product_id,Product_Name,Price from Products
open ArchivedProducts_CURSOR
fetch next from ArchivedProducts_CURSOR into @ProductID, @ProductName, @Price
while @@FETCH_STATUS=0
	begin
		if(@Price>50000)
		insert into ArchivedProducts values(@ProductID,@ProductName,@Price)
		delete from	Products where Product_id=@ProductID
	fetch next from ArchivedProducts_CURSOR into @ProductID, @ProductName, @Price
	end
close ArchivedProducts_CURSOR
deallocate ArchivedProducts_CURSOR

select * from Products
select * from ArchivedProducts