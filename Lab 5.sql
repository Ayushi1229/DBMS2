CREATE TABLE PersonInfo ( 
PersonID INT PRIMARY KEY, 
PersonName VARCHAR(100) NOT NULL, 
Salary DECIMAL(8,2) NOT NULL, 
JoiningDate DATETIME NULL, 
City VARCHAR(100) NOT NULL, 
Age INT NULL, 
BirthDate DATETIME NOT NULL 
);
CREATE TABLE PersonLog ( 
PLogID INT PRIMARY KEY IDENTITY(1,1), 
PersonID INT NOT NULL, 
PersonName VARCHAR(250) NOT NULL, 
Operation VARCHAR(50) NOT NULL, 
UpdateDate DATETIME NOT NULL, 
);

drop table PersonLog
--Part – A 
--1. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table to display a message “Record is Affected.”  
create or alter trigger tr_insertinpersoninfo
on PersonInfo
after insert,update,delete
as
begin 
	print 'Record is affected'
end;

--2. Create a trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo table. For that, 
--log all operations performed on the person table into PersonLog. 

--insert
create or alter trigger tr_Person_after_insert
on PersonInfo
after insert
as
begin
	declare @PersonID int;
	declare @PersonName varchar(100);

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted;

	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	values(@PersonID,@PersonName, 'INSERT', GETDATE())
end;

--update
create or alter trigger tr_Person_after_update
on PersonInfo
after update
as
begin
	declare @PersonID int;
	declare @PersonName varchar(100);

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted;

	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	values(@PersonID,@PersonName, 'UPDATE', GETDATE())
end;

--delete
create or alter trigger tr_Person_after_delete
on PersonInfo
after delete
as
begin
	declare @PersonID int;
	declare @PersonName varchar(100);

	select @PersonID = PersonID from deleted
	select @PersonName = PersonName from deleted;

	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	values(@PersonID,@PersonName, 'DELETE', GETDATE())
end;
--3. Create an INSTEAD OF trigger that fires on INSERT, UPDATE and DELETE operation on the PersonInfo 
--table. For that, log all operations performed on the person table into PersonLog.

--insert
create or alter trigger tr_Person_after_insert_log
on PersonInfo
instead of insert
as
begin
	declare @PersonID int;
	declare @PersonName varchar(100);

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted;

	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	values(@PersonID,@PersonName, 'INSERT', GETDATE())
end;

--update
create or alter trigger tr_Person_after_update_log
on PersonInfo
instead of update
as
begin
	declare @PersonID int;
	declare @PersonName varchar(100);

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted;

	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	values(@PersonID,@PersonName, 'UPDATE', GETDATE())
end;

--delete
create or alter trigger tr_Person_after_delete_log
on PersonInfo
instead of delete
as
begin
	declare @PersonID int;
	declare @PersonName varchar(100);

	select @PersonID = PersonID from deleted;
	select @PersonName = PersonName from deleted;

	insert into PersonLog(PersonID,PersonName,Operation,UpdateDate)
	values(@PersonID,@PersonName, 'DELETE', GETDATE())
end;
--4. Create a trigger that fires on INSERT operation on the PersonInfo table to convert person name into 
--uppercase whenever the record is inserted. 
create or alter trigger tr_Person_insert_uppercase
on PersonInfo
after insert
as
begin
	declare @PersonID int;
	declare @PersonName varchar(100);

	select @PersonID = PersonID from inserted
	select @PersonName = PersonName from inserted;

	update PersonInfo
	set PersonName = UPPER(@PersonName)
	where PersonID = @PersonID
end;
--5. Create trigger that prevent duplicate entries of person name on PersonInfo table. 
create or alter trigger tr_PersonInfo_duplicates
on PersonInfo
instead of insert
as
begin
	insert into PersonInfo(PersonID,PersonName,Salary,JoiningDate,City,Age,BirthDate)
	select PersonID,PersonName, Salary,JoiningDate,City,Age,BirthDate
	from inserted
	where PersonName not in (Select PersonName from PersonInfo)
end
--6. Create trigger that prevent Age below 18 years. 
create or alter trigger tr_PersonInfo_age
on PersonInfo
instead of insert
as
begin
	insert into PersonInfo(PersonID,PersonName,Salary,JoiningDate,City,Age,BirthDate)
	select PersonID,PersonName, Salary,JoiningDate,City,Age,BirthDate
	from inserted
	where age > 18
end
--Part – B 
--7. Create a trigger that fires on INSERT operation on person table, which calculates the age and update 
--that age in Person table. 
create or alter trigger tr_Person_age
on PersonInfo
after insert
as
begin
	 declare @PersonID int, @Age int,@DOB Datetime
	 select @PersonID = PersonID from inserted
	 select @Age = Age from inserted;
	 set @Age =DATEDIFF(year,@DOB,Getdate())
	 update PersonInfo
		set Age = @Age where PersonID=@PersonID
end
--8. Create a Trigger to Limit Salary Decrease by a 10%.
create or alter trigger tr_salary_limit
on personinfo
after insert
as
begin
	declare @sal decimal(8,2)
	declare @pid int
	select @pid = personid from inserted
	select @sal = salary from inserted
	set @sal=@sal-@sal*0.1

	update PersonInfo
	set Salary = @sal
	where PersonID=@pid
end
--Part – C  
--9. Create Trigger to Automatically Update JoiningDate to Current Date on INSERT if JoiningDate is NULL 
--during an INSERT.
create or alter trigger tr_joining_date
on personinfo
after insert
as
begin
	declare @date datetime
	declare @pid int
	select @pid = personid from inserted
	select @date = joiningdate from inserted
	
	update PersonInfo
	set JoiningDate = GETDATE()
	where PersonID=@pid and @date is null
end


create or alter trigger tr_joining_date
on personinfo
after insert
as
begin 
	update personinfo
	set JoiningDate = GETDATE()
	where PersonID in (select personid from inserted)
	and JoiningDate is null
end
--10. Create DELETE trigger on PersonLog table, when we delete any record of PersonLog table it prints 
--‘Record deleted successfully from PersonLog’.
create or alter trigger tr_delete_record
on personlog
after delete
as
begin
	print('Record deleted successfully from PersonLog')
end