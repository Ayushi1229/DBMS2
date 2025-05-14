--Part – A 
-- Create the Customers table

CREATE TABLE Customers (
 Customer_id INT PRIMARY KEY,
 Customer_Name VARCHAR(250) NOT NULL,
 Email VARCHAR(50) UNIQUE
);
-- Create the Orders table

CREATE TABLE Orders (
 Order_id INT PRIMARY KEY,
 Customer_id INT,
 Order_date DATE NOT NULL,
 FOREIGN KEY (Customer_id) REFERENCES Customers(Customer_id)
);

--1. Handle Divide by Zero Error and Print message like: Error occurs that is - Divide by zero error. 
begin try
	declare @num1 int = 10, @num2 int = 0, @result int;
	set @result = @num1/@num2;
end try
begin catch
	print 'Error occurs that is - Divide by zero error'
end catch
--2. Try to convert string to integer and handle the error using try…catch block. 
begin try
	declare @s1 varchar(20) ='ABC',@n int
	set @n=cast(@s1 as int)
end try
begin catch
	print error_message()
end catch
--3. Create a procedure that prints the sum of two numbers: take both numbers as integer & handle 
--exception with all error functions if any one enters string value in numbers otherwise print result. 
create procedure pr_calculation_SumWithErrorHandling
	@num1 nvarchar(50),
	@num2 nvarchar(50)
as begin
	begin try
		declare @intnum1 int = cast(@num1 as int)
		declare @intnum2 int = cast(@num2 as int)
		print 'sum is: ' + cast(@intNum1 + @intNum2 as varchar(50));
	end try
	begin catch
		print 'Error Number: ' + cast(Error_Number() as Varchar(10));
		print 'Error Severity: ' + cast(Error_Severity() as Varchar(10));
		print 'Error State: ' + cast(Error_State() as Varchar(10));
		print 'Error Message: ' + Error_Message()
	end catch
end

--4. Handle a Primary Key Violation while inserting data into customers table and print the error details 
--such as the error message, error number, severity, and state. 
begin try
	insert into Customers(Customer_id,Customer_Name,Email)
	values(1,'John Doe','john@example.com');
end try
begin catch
	print 'Primary Key Violation Error Occurred'
	print 'Error Number: ' + cast(Error_Number() as varchar(10))
	print 'Error Severity: ' + cast(Error_Severity() as Varchar(10))
	print 'Error State: ' + cast(Error_State() as varchar(10))
	print 'Error Message: ' + Error_Message()
end catch
--5. Throw custom exception using stored procedure which accepts Customer_id as input & that throws 
--Error like no Customer_id is available in database.
create procedure pr_customers_CheckCustomerId
	@CustomerId int
as begin
	if not exists (select 1 from Customers where Customer_id = @CustomerId)
	begin 
		throw 50001,'No Customer_id is available in database.', 1;
	end
	else
		begin
			print 'Customer Id exists.'
		end
	end

--Part – B 
--6. Handle a Foreign Key Violation while inserting data into Orders table and print appropriate error 
--message.
begin try
	insert into Orders(Order_id,Customer_id,Order_date) values(1,1,GETDATE())
end try
begin catch
	print('Foreign key violation error occured')
end catch
--7. Throw custom exception that throws error if the data is invalid. 
create or alter procedure pr_datethrows
@value int
as
begin
	if @value<0
	begin
		throw 80000, 'invalid data: Value cannot be negative.', 1;
	end
	else
	begin
		print 'data is valid.';
	end
end
exec pr_datethrows 5
--8. Create a Procedure to Update Customer’s Email with Error Handling 
create or alter procedure pr_update(
@Customer_id int,
@email varchar(100))
as
begin 
	begin try
	update Customers
	set email=@email
	where Customer_id=@customer_id
	end try
	begin catch
		print 'Error occured while updating email'
		print 'Error Number: ' + cast(Error_Number() as nvarchar(10));
		print 'Error Message: ' + Error_Message();
	end catch
end 
exec pr_update 'ayushi@gmail.com',101
--Part – C  
--9. Create a procedure which prints the error message that “The Customer_id is already taken. Try another 
--one”.
--10. Handle Duplicate Email Insertion in Customers Table. 
