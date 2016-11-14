DROP DATABASE if exists starterKit;
CREATE DATABASE starterKit;
USE starterKit;

CREATE TABLE departments (
    departmentName VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (departmentName)
);

CREATE TABLE employees (
    pesel CHAR(11) NOT NULL UNIQUE,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    birthDate DATE NOT NULL,
    departmentName VARCHAR(255) NOT NULL,
    PRIMARY KEY (pesel),
    CONSTRAINT fk_employees_departments FOREIGN KEY (departmentName)
        REFERENCES departments (departmentName)
);

CREATE TABLE projects (
    projectName VARCHAR(255) UNIQUE NOT NULL,
    projectType ENUM('internal', 'external') not null,
    managerPesel CHAR(11) NOT NULL,
    PRIMARY KEY (projectName),
    CONSTRAINT fk_projects_managers FOREIGN KEY (managerPesel)
        REFERENCES employees (pesel)
);

CREATE TABLE employee_project_association (
    id INT NOT NULL AUTO_INCREMENT,
    employeePesel CHAR(11) NOT NULL,
    projectName VARCHAR(255) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE,
    workType ENUM('PL', 'TCD', 'FCD', 'DEV'),
    dailySalary DOUBLE NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_employees FOREIGN KEY (employeePesel)
        REFERENCES employees (pesel),
    CONSTRAINT fk_projects FOREIGN KEY (projectName)
        REFERENCES projects (projectName)
);

