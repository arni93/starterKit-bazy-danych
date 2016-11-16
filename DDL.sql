DROP DATABASE if exists starterKit;
CREATE DATABASE starterKit;
USE starterKit;

CREATE TABLE departments (
    id INT NOT NULL AUTO_INCREMENT, -- nazwa departamentu moze sie zmieniac dlatego nie powinna byc kluczem glownym
    departmentName VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE employees (
    pesel CHAR(11) NOT NULL UNIQUE, -- pesel raczej sie nie zmienia, chyba ze by blednie wprowadzony dlatego nadaje sie na klucz glowny
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    birthDate DATE NOT NULL,
    departmentId int , -- moze byc null(14.11) wg konsultacji
    PRIMARY KEY (pesel),
    CONSTRAINT fk_employees_departments FOREIGN KEY (departmentId)
        REFERENCES departments (id)
);

CREATE TABLE projects (
	id int not null auto_increment,
    projectName VARCHAR(255) UNIQUE NOT NULL,
    projectType ENUM('internal', 'external') not null,
    managerPesel CHAR(11) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_projects_managers FOREIGN KEY (managerPesel)
        REFERENCES employees (pesel)
);

CREATE TABLE employee_project_association (
    id INT NOT NULL AUTO_INCREMENT,
    employeePesel CHAR(11) NOT NULL,
    projectId int NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE,
    workType ENUM('PL', 'TCD', 'FCD', 'DEV'),
    dailySalary DOUBLE NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_employees FOREIGN KEY (employeePesel)
        REFERENCES employees (pesel),
    CONSTRAINT fk_projects FOREIGN KEY (projectId)
        REFERENCES projects (id)
        ON DELETE CASCADE
);

