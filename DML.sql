
insert into departments (departmentName)
values 
('IT'),('HR');

insert into employees (employees.pesel,employees.firstName,employees.lastName,employees.birthDate,employees.departmentName)
values
('93010101014','jan','kowalski','1993-01-01','it'),
('92020202015','ania','kowalska','1992-02-02','hr'),
('91030393016','arkadiusz','pyra','1991-03-03','it'),
('90040411223','monika','starska','1990-04-04','hr'),
('89050522345','robert','niedziela','1989-05-05','it'),
('88060634567','lena','konieczna','1988-06-06','it'),
('87070712345','robert','starski','1987-07-07','it'),
('92080854321','tomasz','letachowicz','1986-08-08','hr'),
('79090953124','krzysztof','jarzyna','1979-09-09','it'),
('85101067890','krystian','czarnecki','1985-10-10','it'),
('91111124567','krystyna','ruchala','1991-11-11','hr');

insert into projects (projects.projectName, projects.projectType, projects.managerPesel)
values 
('starterkit','internal','79090953124'),
('bmw', 'external', '90040411223');

insert into employee_project_association (employeePesel, projectName,startDate, endDate, workType, dailySalary)
values
('93010101014','starterkit','2016-07-01','2016-09-30','DEV',150),
('91030393016','starterkit','2016-07-01','2016-09-30','DEV',150),
('89050522345','starterkit','2016-07-01','2016-09-30','DEV',150),
('88060634567','starterkit','2016-10-01','2016-12-30','DEV', 150),
('85101067890','starterkit','2016-10-01','2016-12-30', 'FCD', 150),
('90040411223','starterkit','2016-10-01','2016-12-30', 'PL', 300),
('93010101014','bmw','2016-10-01', null ,'DEV',300),
('91030393016','bmw','2016-10-01', null ,'DEV',300),
('89050522345','bmw','2016-10-01', null ,'DEV',300),
('87070712345','bmw','2014-01-01','2015-01-01' ,'DEV',300),
('87070712345','bmw','2015-01-02',null,'TCD',500),
('79090953124','bmw','2013-03-15',null, 'PL', 1000),
('85101067890','bmw','2013-04-15','2014-03-30','DEV',400),
('85101067890','bmw','2013-04-15',null,'FCD',600);


