
insert into departments (id, departmentName)
values 
(1,'IT'),(2,'HR');

insert into employees (employees.pesel,employees.firstName,employees.lastName,employees.birthDate,employees.departmentId)
values
('01234567890','bez','departamentu','2000-02-02', null),
('93010101014','jan','kowalski','1993-01-01',1),
('92020202015','ania','abralska','1992-02-02',2),
('91030393016','arkadiusz','skira','1991-03-03',1),
('90040411223','monika','starska','1990-04-04',2),
('89050522345','robert','niedziela','1989-05-05',1),
('88060634567','lena','kfonieczna','1988-06-06',1),
('87070712345','robert','starski','1987-07-07',1),
('92080854321','tomasz','lFetachowicz','1986-08-08',2),
('79090953124','krzysztof','jarzyna','1979-09-09',1),
('85101067890','krystian','czarnecki','1985-10-10',1),
('91111124567','krystyna','ruchala','1991-11-11',2);

insert into projects (projects.id, projects.projectName, projects.projectType, projects.managerPesel)
values 
(1, 'starterkit','internal','79090953124'),
(2, 'bmw', 'external', '90040411223');

insert into employee_project_association (employeePesel, projectId,startDate, endDate, workType, dailySalary)
values
('93010101014',1,'2016-07-01','2016-09-30','DEV',150),
('91030393016',1,'2016-07-01','2016-09-30','DEV',150),
('89050522345',1,'2016-07-01','2016-09-30','DEV',150),
('88060634567',1,'2016-10-01','2016-12-30','DEV', 150),
('85101067890',1,'2016-10-01','2016-12-30', 'FCD', 150),
('90040411223',1,'2015-10-01','2016-12-30', 'PL', 300),
('79090953124',1,'2015-10-01','2016-12-30', 'PL', 600),
('93010101014',2,'2016-10-01', null ,'DEV',300),
('91030393016',2,'2016-10-01', null ,'DEV',300),
('89050522345',2,'2016-10-01', null ,'DEV',300),
('87070712345',2,'2014-01-01','2015-01-01' ,'DEV',300),
('87070712345',2,'2015-01-02',null,'TCD',500),
('79090953124',2,'2013-03-15',null, 'PL', 1000),
('85101067890',2,'2013-04-15','2014-03-30','DEV',400),
('85101067890',2,'2013-04-15',null,'FCD',600);


