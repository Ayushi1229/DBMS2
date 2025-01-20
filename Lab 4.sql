--Part – A 
--1. Write a function to print "hello world". 
create or alter function fn_HelloWorld()
returns varchar(50)
as
begin
	return 'Hello World'
end;

select dbo.fn_HelloWorld()
--2. Write a function which returns addition of two numbers. 
create or alter function fn_addition(@num1 int,@num2 int)
returns int
as
begin
	return @num1+@num2
end

select dbo.fn_addition(5,3) as sum
--3. Write a function to check whether the given number is ODD or EVEN. 
create or alter function fn_oddeven(@num int)
returns varchar(50)
as
begin
	declare @msg varchar(50)
	if @num%2=0
		set @msg='Even'
	else
		set @msg='Odd'
	return @msg
end

select dbo.fn_oddeven(5)
--4. Write a function which returns a table with details of a person whose first name starts with B. 
create or alter function fn_firstname()
returns table
as
	return(
	select * from Person
	where FirstName like 'B%')

select * from dbo.fn_firstname()
--5. Write a function which returns a table with unique first names from the person table.
create or alter function fn_uniquefirstname()
returns table
as
	return(select distinct firstname from Person)

select * from dbo.fn_uniquefirstname()
--6. Write a function to print number from 1 to N. (Using while loop) 
create or alter function fn_1toN(@N int)
returns varchar(50)
as
begin
	declare @msg varchar(200),@count int
	set @msg =' '
	set @count=1
	while (@count<=@N)
	begin
		set @msg = @msg + ' ' + cast(@count as varchar)
		set @count = @count + 1
	end
	return @msg
end

select dbo.fn_1toN(10)
--7. Write a function to find the factorial of a given integer. 
create or alter function fn_factorial(@Number int)
returns bigint
as
begin
	declare @fac int, @i int
	set @fac =1
	set @i = 1
	while(@i<=@number)
	begin
		set @fac=@fac*@i
		set @i=@i+1
	end
	return @fac
end

select dbo.fn_factorial(5) as factorial

--Part – B 
--8. Write a function to compare two integers and return the comparison result. (Using Case statement)
create or alter function fn_compareinteger(@n1 int ,@n2 int)
returns varchar(20)
as
begin
	return case
			when @n1>@n2 then '1st is greater'
			when @n2>@n1 then '2nd is greater'
			else 'both are equal'
		end
end

select dbo.fn_compareinteger(5,8) as comparison
--9. Write a function to print the sum of even numbers between 1 to 20. 
create or alter function fn_evensum()
returns int
as
begin
	declare @sum int, @count int
	set @sum = 0
	set @count = 1
	while (@count<=20)
	begin
		if(@count%2=0)
		set @sum=@sum+@count
		set @count=@count+1
	end
	return @sum
end

select dbo.fn_evensum() as EvenSum
--10. Write a function that checks if a given string is a palindrome 
create or alter function fn_palindrom(@num int)
returns varchar(50)
as
begin
	declare @ans varchar(50),@rem int,@org int, @sum int
	--set @ans = ' '
	set @org = @num
	set @sum = 0
	while(@num>0)
		begin
			set @rem = @num%10
			set @sum = (10*@sum) + @rem
			set @num = @num/10
		end
	if (@sum=@org)
		set @ans = 'Palindrom'
	else
		set @ans ='Not Palindrom'
	return @ans
end

select dbo.fn_palindrom(12321)

--2nd method
CREATE OR ALTER FUNCTION fn_palindrom_string(@inputString VARCHAR(100))
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN CASE 
        WHEN @inputString = REVERSE(@inputString) THEN 'Palindrome'
        ELSE 'Not Palindrome'
    END;
END;

select dbo.fn_palindrom_string('madam')
--Part – C 
--11. Write a function to check whether a given number is prime or not.
CREATE OR ALTER FUNCTION fn_is_prime(@num INT)
RETURNS VARCHAR(50)
AS
BEGIN
    IF @num < 2
        RETURN 'Not a Prime Number'
    DECLARE @i INT = 2
    WHILE @i <= SQRT(@num)
    BEGIN
        IF @num % @i = 0
            RETURN 'Not a Prime Number'
        SET @i = @i + 1
    END
    RETURN 'Prime Number'
END

select dbo.fn_is_prime(5)
--12. Write a function which accepts two parameters start date & end date, and returns a difference in days. 
create or alter function fn_DateDifference(@startdate date,@enddate date)
returns int
as
begin
	return datediff(day,@startdate,@enddate)
end

select dbo.fn_DateDifference('2024-01-01','2024-01-03')
--13. Write a function which accepts two parameters year & month in integer and returns total days each year. 
create or alter function fn_totaldaysinmonth(@year int,@month int)
returns int
as
begin
	declare @ans varchar(50), @date date, @day int
	set @ans = cast(@year as varchar)+ '-' + cast(@month as varchar)+'-1'
	set @date = cast(@ans as date)

	set @day = day(eomonth(@date))
	return @day
end

select dbo.fn_totaldaysinmonth(2021,5)
--14. Write a function which accepts departmentID as a parameter & returns a detail of the persons. 
CREATE or alter FUNCTION fn_GetPersonsByDepartment(@id INT)
RETURNS TABLE
AS
RETURN(SELECT * FROM Person p
		join Department d
		on p.DepartmentID=d.DepartmentID
    WHERE 
        d.DepartmentID = @id
);



select * from dbo.fn_deptid(1)
--15. Write a function that returns a table with details of all persons who joined after 1-1-1991.
CREATE FUNCTION fn_GetPersonsJoinedAfter1991()
RETURNS TABLE
AS
RETURN
(
    SELECT * FROM Person p
	join Department d
	on p.DepartmentID=d.DepartmentID
    WHERE 
        p.JoiningDate > '1991-01-01'
);
