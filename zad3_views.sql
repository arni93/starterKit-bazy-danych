
-- SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DROP VIEW IF EXISTS employees_project;
CREATE VIEW employees_project AS
    SELECT 
        employees.firstName AS IMIE,
        employees.lastName AS NAZWISKO,
        projects.projectName AS PROJEKT
    FROM
        employees
            LEFT JOIN
        employee_project_association ON employees.pesel = employee_project_association.employeePesel
            LEFT JOIN
        projects ON employee_project_association.projectId = projects.id
    WHERE
        employee_project_association.endDate >= CURRENT_DATE()
            OR employee_project_association.endDate IS NULL
    ORDER BY IMIE , NAZWISKO , PROJEKT;

-- SELECT * FROM employees_project;