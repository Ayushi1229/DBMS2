--AFTER TRIGGER

CREATE TABLE EMPLOYEEDETAILS
(
	EmployeeID Int Primary Key,
	EmployeeName Varchar(100) Not Null,
	ContactNo Varchar(100) Not Null,
	Department Varchar(100) Not Null,
	Salary Decimal(10,2) Not Null,
	JoiningDate DateTime Null
)
CREATE TABLE EmployeeLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    EmployeeName VARCHAR(100) NOT NULL,
    ActionPerformed VARCHAR(100) NOT NULL,
    ActionDate DATETIME NOT NULL
);
--1)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to display the message "Employee record inserted", "Employee record updated", "Employee record deleted"

--insert
create or alter trigger tr_insert
on employeedetails
after insert
as
begin
	print 'Employee record inserted'
end

--update
create or alter trigger tr_update
on employeedetails
after update
as
begin
	print 'Employee record updated'
end

--delete
create or alter trigger tr_delete
on employeedetails
after delete
as
begin
	print 'Employee record deleted'
end
--2)	Create a trigger that fires AFTER INSERT, UPDATE, and DELETE operations on the EmployeeDetails table to log all operations into the EmployeeLog table.

--insert
create or alter trigger tr_emp_log_insert
on Employeedetails
after insert
as
begin
	declare @eid int;
	declare @ename varchar(100);

	select @eid = Employeeid from inserted
	select @ename = Employeename from inserted

	insert into EmployeeLog(EmployeeID, EmployeeName, Operation, Updatedate)
	values(@eid, @ename, 'INSERT', getdate())
end

--update
create or alter trigger tr_emp_log_update
on Employeedetails
after update
as
begin
	declare @eid int;
	declare @ename varchar(100);

	select @eid = Employeeid from inserted
	select @ename = Employeename from inserted

	insert into EmployeeLog(EmployeeID, EmployeeName, Operation, Updatedate)
	values(@eid, @ename, 'UPDATE', getdate())
end

--delete
create or alter trigger tr_emp_log_delete
on Employeedetails
after delete
as
begin
	declare @eid int;
	declare @ename varchar(100);

	select @eid = Employeeid from deleted
	select @ename = Employeename from deleted

	insert into EmployeeLog(EmployeeID, EmployeeName, Operation, Updatedate)
	values(@eid, @ename, 'DELETE', getdate())
end

--3)	Create a trigger that fires AFTER INSERT to automatically calculate the joining bonus (10% of the salary) for new employees and update a bonus column in the EmployeeDetails table.
CREATE or alter TRIGGER tr_CalculateJoiningBonus
ON EmployeeDetails
after insert
as
BEGIN
	declare @eid int;
	
	select @eid = EmployeeID from inserted
		update EMPLOYEEDETAILS
		set Salary = salary*1.1
		where EmployeeID=@eid
end
--4)	Create a trigger to ensure that the JoiningDate is automatically set to the current date if it is NULL during an INSERT operation.
create or alter trigger tr_joiningdate
on employeedetails
after insert
as
begin
	declare @date datetime;
	declare @eid int;

	select @eid = employeeid from inserted
	select @date = joiningdate from inserted

	update EMPLOYEEDETAILS
	set JoiningDate = getdate()
	where employeeid = @eid and @date is null
end
--5)	Create a trigger that ensure that ContactNo is valid during insert(Like ContactNo length is 10)
create or alter trigger tr_contactno
on employeedetails
for insert
as
begin
	declare @eid int
	declare @con varchar(100)

	select @eid = employeeid, @con = contactno from inserted
	if len(@con)!=10
	begin	
		delete EMPLOYEEDETAILS where employeeid = @eid
	end
end



--INSTEAD OF TRIGGER
CREATE TABLE Movies (
    MovieID INT PRIMARY KEY,
    MovieTitle VARCHAR(255) NOT NULL,
    ReleaseYear INT NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 1) NOT NULL,
    Duration INT NOT NULL
);

CREATE TABLE MoviesLog
(
	LogID INT PRIMARY KEY IDENTITY(1,1),
	MovieID INT NOT NULL,
	MovieTitle VARCHAR(255) NOT NULL,
	ActionPerformed VARCHAR(100) NOT NULL,
	ActionDate	DATETIME  NOT NULL
);

--1.	Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the Movies table. For that, log all operations performed on the Movies table into MoviesLog.

--insert
create or alter trigger tr_movie_insert
on movies
instead of insert
as
begin
	declare @mid int;
	declare @mname varchar(100)
	
	select @mid=movieid,@mname = movietitle from inserted
	insert into movieslog values(@mid, @mname, 'insert', getdate())
end

--update
create or alter trigger tr_movie_update
on movies
instead of update
as
begin
	declare @mid int;
	declare @mname varchar(100)
	
	select @mid=movieid,@mname = movietitle from inserted
	insert into movieslog values(@mid, @mname, 'update', getdate())
end

--delete
create or alter trigger tr_movie_update
on movies
instead of delete
as
begin
	declare @mid int;
	declare @mname varchar(100)
	
	select @mid=movieid,@mname = movietitle from deleted
	insert into movieslog values(@mid, @mname, 'delete', getdate())
end
--2.	Create a trigger that only allows to insert movies for which Rating is greater than 5.5 .
create or alter trigger tr_insert_movie
on Movies 
instead of insert
as
begin
	declare @rating DECIMAL(3, 1)
	if(@rating > 5.5)
		insert into Movies(MovieID , MovieTitle , ReleaseYear , Genre , Rating , Duration )
		select *
		from inserted
end

--3.	Create trigger that prevent duplicate 'MovieTitle' of Movies table and log details of it in MoviesLog table.
create or alter trigger tr_prevent_duplicate_movies
on Movies 
instead of insert
as
begin
	insert into Movies(MovieID , MovieTitle , ReleaseYear , Genre , Rating , Duration )
	select *
	from inserted
	where MovieTitle not in (select MovieTitle from Movies)

	declare @movieID int, @movieTitle VARCHAR(255) 
	select @movieID = MovieID  from inserted
	select @movieTitle = MovieTitle  from inserted

	insert into MoviesLog
	values (@movieID, @movieTitle, 'movie insert', getdate())
end

--4.	Create trigger that prevents to insert pre-release movies.
create or alter trigger tr_prevent_preRelease_movie
on Movies 
instead of insert
as
begin
	insert into Movies (MovieID , MovieTitle , ReleaseYear , Genre , Rating , Duration )
	select *
	from inserted
	where ReleaseYear > getdate()
end

--5.	Develop a trigger to ensure that the Duration of a movie cannot be updated to a value greater than 120 minutes (2 hours) to prevent unrealistic entries.
------------insert----------
create or alter trigger tr_prevent_unrealistic_movies
on Movies 
instead of insert
as
begin
	declare @duration INT, @movieID int 
	select @duration = Duration  from Movies 
	if(@duration < 120)
		update Movies 
		set Duration = @duration
		where MovieID = @movieID
	else
		print('unrealistic entries')
	--insert into Movies (MovieID , MovieTitle , ReleaseYear , Genre , Rating , Duration )
	--select *
	--from inserted
	--where MovieTitle not in (select MovieTitle from Movies)
end
