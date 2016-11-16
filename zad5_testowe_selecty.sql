-- przykladowe selecty do sprawdzania dzialania dodanych uzytkownikow i ich uprawnien

insert into projects (projects.id, projects.projectName, projects.projectType, projects.managerPesel) values 
(3, 'nowy_projekt','internal','01234567890');

insert into departments (departments.id, departments.departmentName) values
(3,'nowy_department');

delete from projects where projects.id = 3; 

select * from projects;

select * from departments;