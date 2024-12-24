-- Create Department Table 
CREATE TABLE Department ( 
DepartmentID INT PRIMARY KEY, 
DepartmentName VARCHAR(100) NOT NULL UNIQUE 
);
-- Create Designation Table 
CREATE TABLE Designation ( 
DesignationID INT PRIMARY KEY, 
DesignationName VARCHAR(100) NOT NULL UNIQUE 
); 
-- Create Person Table 
CREATE TABLE Person ( 
PersonID INT PRIMARY KEY IDENTITY(101,1), 
FirstName VARCHAR(100) NOT NULL, 
LastName VARCHAR(100) NOT NULL, 
Salary DECIMAL(8, 2) NOT NULL, 
JoiningDate DATETIME NOT NULL, 
DepartmentID INT NULL, 
DesignationID INT NULL, 
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID), 
FOREIGN KEY (DesignationID) REFERENCES Designation(DesignationID) 
);

--Part – A 
--1. Department, Designation & Person Table’s INSERT, UPDATE & DELETE Procedures. 
--STORED PROCEDURE FOR INSERT--
--DEPARTMENT TABLE--

create procedure PR_department_insert
	@DepartmentID int,
	@DepartmentName varchar(100)
as 
begin
	insert into Department(DepartmentID,DepartmentName)
	values(@DepartmentID,@DepartmentName)
end

exec PR_department_insert 1,'Admin'
exec PR_department_insert 2,'IT'
exec PR_department_insert 3,'HR'
exec PR_department_insert 4,'Account'

select * from Department


--DESIGNATION TABLE--
create or alter procedure PR_designation_insert
	@DesignationID int,
	@DesignationName varchar(100)
as
begin
	insert into Designation(DesignationID,DesignationName)
	values(@DesignationID,@DesignationName)
end

exec PR_designation_insert 11,'Jobber'
exec PR_designation_insert 12,'Welder'
exec PR_designation_insert 13,'Clerk'
exec PR_designation_insert 14,'Manager'
exec PR_designation_insert 15,'CEO'

select * from Designation


--PERSON TABLE--
create or alter procedure PR_person_insert
	@FirstName VARCHAR(100),
	@LastName VARCHAR(100),
	@Salary DECIMAL(8, 2),
	@JoiningDate DATETIME,
	@DepartmentID INT,
	@DesignationID INT
as
begin
	insert into Person
	(FirstName,LastName,Salary,JoiningDate,DepartmentID,DesignationID)
	values 
	(@FirstName,@LastName,@Salary,@JoiningDate,@DepartmentID,@DesignationID)
end

exec PR_person_insert 'Rahul','Anshu',56000,'1990-01-01',1,12
exec PR_person_insert 'Hardik','Hinsu',18000,'1990-09-25',2,11
exec PR_person_insert 'Bhavin','Kamani',25000,'1991-05-14',null,11
exec PR_person_insert 'Bhoomi','Patel',39000,'2014-02-20',1,13
exec PR_person_insert 'Rohit','Rajgor',17000,'1990-07-23',2,15
exec PR_person_insert 'Priya','Mehta',25000,'1990-10-18',2,null
exec PR_person_insert 'Neha','Trivedi',18000,'2014-02-20',3,15

select * from Person
truncate table person

--STORED PROCEDURE FOR UPDATE--
--DEPARTMENT TABLE--
create or alter procedure PR_Department_Update
	@DeptId int,
	@DeptName varchar(50)
as
begin
	update Department
	set DepartmentName = @DeptName
	where DepartmentID = @DeptId
end

exec PR_Department_Update 1,'abc'
exec PR_Department_Update 1,'Admin'

select * from department

--DESIGNATION TABLE--
create or alter procedure PR_Designation_Update
	@DesignationId int,
	@DesignationName varchar(50)
as
begin 
	update Designation
	set DesignationName =@DesignationName
	where DesignationID =@DesignationId
end

exec PR_Designation_Update 11,'barber'
exec PR_Designation_Update 11,'jobber'

select * from Designation

--PERSON TABLE--
create or alter procedure PR_Person_Update
	@PersonId int,
	@Firstname varchar(100),
	@Lastname varchar(100),
	@Salary decimal(8,2),
	@JoiningDate datetime,
	@DepartmentID int,
	@DesignationID int
as 
begin
	update person
	set FirstName = @Firstname,
		LastName = @Lastname,
		Salary = @Salary,
		JoiningDate = @JoiningDate,
		DepartmentID = @DepartmentID,
		DesignationID = @DesignationID
	where PersonID= @PersonId
end

exec PR_Person_Update 101,'jay','Sharma',60000,'1990-01-01',1,12
select * from Person

--STORED PROCEDURE FOR DELETE--
--DEPARTMENT TABLE--
create or alter procedure PR_Department_Delete
	@DepartmentId int
as
begin 
	delete from Department
	where DepartmentID = @DepartmentId
end

--DESIGNATION TABLE--
create or alter procedure PR_Designation_Delete
	@DesignationId int
as
begin
	delete from Designation
	where DesignationID = @DesignationId
end

--PERSON TABLE--
create or alter procedure PR_Person_Delete
	@PersonId int
as
begin
	delete from Person
	where PersonID = @PersonId
end

--2. Department, Designation & Person Table’s SELECTBYPRIMARYKEY 
--department table--
create or alter procedure PR_Department_PK
	@DepartmentId int
as
begin
	select * from Department
	where DepartmentID = @DepartmentId
end

--designation table--
create or alter procedure PR_Designation_PK
	@DesignationId int
as
begin
	select * from Designation
	where DesignationID = @DesignationId
end

--person table--
create or alter procedure PR_Person_PK
	@PersonId int
as 
begin
	select * from Person
	where PersonID = @PersonId
end


--3. Department, Designation & Person Table’s (If foreign key is available then do write join and take 
--columns on select list) 
--Department table--
create or alter procedure PR_Department_FK
as
begin 
	select * from Department
end

--Designation Table--
create or alter procedure PR_Designation_FK
as
begin
	select * from Designation
end

--Person Table--
create or alter procedure PR_Person_FK
as
begin
	select p.PersonID,
		   p.FirstName,
		   p.LastName,
		   p.Salary,
		   p.JoiningDate,
		   p.DepartmentID,
		   p.DesignationId,
		   DepartmentName,
		   DesignationName 
	from Person p
	full outer join Department dept
	on p.DepartmentID=dept.DepartmentID
	full outer join Designation d
	on p.DesignationID = d.DesignationID
end

exec PR_Person_FK
--4. Create a Procedure that shows details of the first 3 persons.
create or alter procedure PR_Person_detail
as
begin
	select top 3 * from Person P
	join Department dept
	on p.DepartmentID=dept.DepartmentID
	join Designation d
	on p.DesignationID = d.DesignationID
end

exec PR_Person_detail

--Part – B 
--5. Create a Procedure that takes the department name as input and returns a table with all workers 
--working in that department.
create or alter procedure PR_Worker_Detail
	@DeptName varchar(100)
as
begin
	select * from department d
	join person p
	on d.DepartmentID = p.DepartmentID
	where d.DepartmentName = @DeptName
end

exec PR_Worker_Detail IT


--6. Create Procedure that takes department name & designation name as input and returns a table with 
--worker’s first name, salary, joining date & department name. 
create or alter procedure PR_worker
	@deptname varchar(100),
	@designationname varchar(100)
as 
begin
	select p.firstname, p.salary, p.joiningdate, dept.departmentname
	from person p
	join Department dept
	on p.DepartmentID = dept.DepartmentID
	join Designation d 
	on p.DesignationID =d.DesignationID
	where dept.DepartmentName = @deptname and
		  d.DesignationName = @designationname
end

exec PR_worker 'admin','welder'

--7. Create a Procedure that takes the first name as an input parameter and display all the details of the 
--worker with their department & designation name. 
create or alter procedure PR_firstname
	@firstname varchar(50)
as
begin 
	select * from Person p
	right outer join Department dept
	on p.DepartmentID=dept.DepartmentID
	right outer join Designation d
	on p.DesignationID = d.DesignationID
	where p.FirstName = @firstname
end

exec PR_firstname 'Bhoomi'

--8. Create Procedure which displays department wise maximum, minimum & total salaries. 
create or alter procedure PR_Salary
as
begin
	select d.departmentName, max(p.salary) as max, min(p.salary) as min, avg(p.salary) as avg
	from person p
	join Department d
	on p.DepartmentID =d.DepartmentID
	group by d.DepartmentName
end

exec PR_Salary
--9. Create Procedure which displays designation wise average & total salaries. 
create or alter procedure PR_Salary_Designation
as
begin
	select d.designationName, avg(p.salary) as avg, sum(p.salary) as total
	from person p
	join Designation d
	on p.DesignationID= d.DesignationID
	group by d.DesignationName
end

exec PR_Salary_Designation
--Part – C 
--10. Create Procedure that Accepts Department Name and Returns Person Count. 
create or alter procedure PR_PersonCount
	@Deptname varchar(50)
as
begin
	select d.departmentName, count(p.personid) as personcount
	from person p
	join Department d
	on p.DepartmentID =d.DepartmentID
	 WHERE 
        d.DepartmentName = @Deptname
    GROUP BY 
        d.DepartmentName;
end
exec PR_PersonCount 'it'
--11. Create a procedure that takes a salary value as input and returns all workers with a salary greater than 
--input salary value along with their department and designation details. 
create or alter procedure PR_Salaryvalue
	@Salary decimal(8,2)
as
begin
	select * from person p
	join Department dept
	on p.DepartmentID =dept.DepartmentID
	join Designation d
	on p.DesignationID =d.DesignationID
	where p.Salary> @Salary
end

exec PR_Salaryvalue 10000.00

--12. Create a procedure to find the department(s) with the highest total salary among all departments.
create or alter procedure PR_highest
as
begin 
	select d.departmentname, sum(p.salary) as total
	from person p
	join Department d
	on p.DepartmentID= d.DepartmentID
	group by d.DepartmentName
	having sum(p.salary) = (select max(p.salary) as highest_total
							from person p)
							
end	

exec PR_highest
--13. Create a procedure that takes a designation name as input and returns a list of all workers under that 
--designation who joined within the last 10 years, along with their department.
create or alter procedure PR_Designation_detail
@designationname varchar(50)
as
begin
	select * from person p
	join Department dept
	on p.DepartmentID = dept.DepartmentID
	join Designation d
	on p.DesignationID = d.DesignationID
	where DesignationName = @designationname and p.JoiningDate<=DATEADD(YEAR, -10, GETDATE());
end

exec PR_Designation_detail 'ceo'
--14. Create a procedure to list the number of workers in each department who do not have a designation 
--assigned. 
create or alter procedure PR_list
as
begin
	select	dept.departmentname as department,
			count(p.personid) as number
	from person p
	join Department dept
	on p.DepartmentID =dept.DepartmentID
	join Designation d
	on p.DesignationID=d.DesignationID
	where d.DesignationID is null
	group by dept.DepartmentName
end

exec PR_list

--15. Create a procedure to retrieve the details of workers in departments where the average salary is above 
--12000.

create or alter procedure PR_WorkerDetail
as
begin 
	select * from person 
	where avg(Salary)>12000
end