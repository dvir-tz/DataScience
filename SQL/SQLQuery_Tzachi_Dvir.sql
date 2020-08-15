select *
from [departments] ;

select * 
from [Students] ;

select * 
from [courses] ;

select
from [classrooms] ;

select *
from [teachers] ;


--------------------------------------

2. a

 select a.departmentID,
		a.DepartmentName,
		b.courseID,
		c.StudentId
		from [departments] as a 
		inner join courses as b
		on a.departmentID = b.DepartmentID
		inner join classrooms as c
		on b.courseID=c.courseID

select
a.DepartmentId,
a.DepartmentName,
a.courseID,
a.StudentID into
dbo.Students_Departments
from (select a.*,
		b.courseID,
		c.StudentId
		from [departments] as a 
		inner join courses as B
		on a.departmentID = b.DepartmentID
		inner join classrooms as c
		on b.courseID=c.courseID) as a;

select * from students_departments;

select DepartmentID ,DepartmentName,
count(distinct StudentID) as Students_total
 from Students_Departments
group by DepartmentID, departmentName
order by departmentID;


---------------------------------------

2.b

select * from students_departments;


select distinct courseID, DepartmentID ,DepartmentName,
count(*) as Students_total
from Students_Departments
where DepartmentName= 'english'
group by courseID, DepartmentID, departmentName;


select
sum (a.Students_total)
from 
(
select distinct courseID, DepartmentID ,DepartmentName,
count(*) as Students_total
from Students_Departments
where DepartmentName= 'english'
group by courseID, DepartmentID, departmentName
) as a

--------------------------------------
2.c

select distinct courseID, DepartmentID ,DepartmentName,
count(*) as Students_total,
case when (count(*)<22) then (1)
		else (2)
		end as OverUnder22_std
		into #OverUnder22_std
from Students_Departments
where DepartmentName= 'science'
group by courseID, DepartmentID, departmentName
order by count(*);

select distinct DepartmentID, departmentName,
(select count(overunder22_std) from #OverUnder22_std where overunder22_std =1) as under22_std,
(select count(overunder22_std) from #OverUnder22_std where overunder22_std =2) as over22_std
from #OverUnder22_std

select * from #OverUnder22_std
---------------------------------------------

2.d

select * 
from [Students] ;

select distinct Gender,
count(*) as Students_total
from Students
group by Gender;

----------------------------------------------

2.e





select * 
from [Students] ;


select * 
from [courses] ;

select * 
from [Classrooms] 


select a.CourseName, a.courseID,
		b.StudentId,
		c.Gender
		into dbo.Courses_Std_Gen
	from [courses] as a
	inner join [Classrooms]  as b
	on a.courseID=b.courseID
		inner join [Students]  as c
		on 	b.StudentId=c.StudentId;

select * from dbo.Courses_Std_Gen

select distinct courseName,courseID,count(StudentId) as M_std
into #Courses_Std_M
from dbo.Courses_Std_Gen
where gender= 'm' 
group by courseName,courseID

select distinct courseName,courseID,count(StudentId) as F_std
into #Courses_Std_F
from dbo.Courses_Std_Gen
where gender= 'f'
group by courseName,courseID


select a.CourseName, a.courseID, a.M_std,
		b.F_std
	into #Courses_Std_M_F
	from #Courses_Std_M as a
	inner join #Courses_Std_F  as b
	on a.courseID=b.courseID

select * from #Courses_Std_M_F

select CourseName, courseID, M_std, F_std, M_std*1.0/(M_std+F_std)*100 as M_pct, f_std*1.0/(M_std+F_std)*100 as F_pct
from #Courses_Std_M_F
where (M_std*1.0/(M_std+F_std)*100)>=70 or (f_std*1.0/(M_std+F_std)*100)>=70



------------------------------------
2.f

select a.CourseName, a.courseID,
		b.StudentId,
		b.degree,
		c.Gender,
		d.departmentName,
		d.departmentID
		into dbo.Courses_Std_degree
	from [courses] as a
	inner join [Classrooms]  as b
	on a.courseID=b.courseID
		inner join [Students]  as c
		on 	b.StudentId=c.StudentId
		inner join [departments] as d
	on a.DepartmentID=d.DepartmentID;

	select * from dbo.Courses_Std_degree



select distinct departmentName ,departmentID,
count(studentId) as Students_over80
--into dbo.Courses_grade_over80
from dbo.Courses_Std_degree
where degree> 80
group by departmentName, departmentID;


select distinct departmentName ,departmentID,
count(studentId) as Students_total
--into dbo.Courses_all_Grades
from dbo.Courses_Std_degree
group by departmentName, departmentID;



select a.departmentName,
		a.departmentID,
		a.Students_over80,
		b.Students_total
		into #Courses_Std_over80_pct
	from dbo.Courses_grade_over80 as a
	inner join dbo.Courses_all_Grades  as b
	on a.departmentName=b.departmentName;

select departmentName, departmentID, Students_over80, Students_total, Students_over80 * 1.0/Students_total *100 as pct_over80
from #Courses_Std_over80_pct
----------------------------------------
2.g

select distinct departmentName ,departmentID,
count(studentId) as Students_undr60
into dbo.Courses_grade_under60
from dbo.Courses_Std_degree
where degree< 60
group by departmentName, departmentID;


select * from Courses_grade_under60

select distinct departmentName ,departmentID,
count(studentId) as Students_total
--into dbo.Courses_all_Grades
from dbo.Courses_Std_degree
group by departmentName, departmentID;

select a.departmentName,
		a.departmentID,
		a.Students_undr60,
		b.Students_total
	into #Courses_Std_under60_pct
	from dbo.Courses_grade_under60 as a
	inner join dbo.Courses_all_Grades  as b
	on a.departmentName=b.departmentName;

select * from #Courses_Std_under60_pct

select departmentName, departmentID, Students_undr60, Students_total, Students_undr60 * 1.0/Students_total *100 as pct_under60
from #Courses_Std_under60_pct

		
-----------------------------

2.h

select * from dbo.Teachers

select *
from [departments] ;

select * 
from [Students] ;

select * 
from [courses] ;

select *
from [classrooms] ;

select *
from [teachers] ;


select  c.TeacherID,
	    c.FirstName as FirstName_teach,
		c.LastName as LastName_teach,
		a.degree,
		a.StudentId
	into dbo.Teachers_AVG_Grads
	from [Classrooms] as a
	inner join [courses] as b
	on a.courseID=b.courseID
		inner join [Teachers]  as c
		on 	b.TeacherId=c.TeacherId;

select *
from dbo.Teachers_AVG_Grads ;

select distinct TeacherID ,FirstName_teach, LastName_teach,
avg(degree) as avg_std_degree
from dbo.Teachers_AVG_Grads
group by TeacherID ,FirstName_teach, LastName_teach
order by avg(degree) desc;

----------------------------------------------

3.a

create view Dep_Courses_numStd_v as
select count(a.StudentId) as Students_num , 
       b.courseName,
	   c.departmentName,
	   d.FirstName as F_TeacherName,
	   d.LastName as L_TeacherName
from classrooms as a
inner join courses as b
on a.CourseId= b.CourseId
inner join departments as c
on b.departmentId= c.departmentId
inner join Teachers as d
on b.TeacherId= d.TeacherId
group by  b.courseName,
	   c.departmentName,
	   d.FirstName,
	   d.LastName;

	
select * from Dep_Courses_numStd_v

---------------------------------

3.b

create view Students_dep_Grade_v as
select a.FirstName as F_Name_std, 
       a.LastName as L_Name_std,
	   d.DepartmentName as Department,
	   count(c.courseID) as num_courses,
	   avg(b.degree) as avg_degree   
from students as a
left outer join classrooms as b
on a.StudentId= b.StudentId
left outer join Courses as c
on b.courseId= c.courseId
left outer join Departments as d
on c.DepartmentID= d.DepartmentID
group by  a.FirstName,
	   a.LastName,
	   d.DepartmentName;

select * from Students_dep_Grade_v


create view Students_avg_sum_v as
select F_Name_std, 
       L_Name_std,
	   count(Department) as dep_num,
	   count(num_courses) as num_courses,
	   avg(avg_degree) as avg_sum
from Students_dep_Grade_v
group by F_Name_std, 
       L_Name_std
	   --order by F_Name_std ;

select * from Students_avg_sum_v
