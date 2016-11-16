-- select * from employees;

-- ponizsza instrukcja wymusza poprawne dzialanie groupBy w mySql
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- podpunkt a) znajdz pracownikow starszych niz X lat
-- wiek wpisany na stale w zapytanie
SELECT 
    *
FROM
    employees
WHERE
    YEAR(FROM_DAYS(DATEDIFF(CURRENT_DATE(), employees.birthDate))) > 30;
    


-- podpunkt a.1) znajdz pracownikow w ktorych nazwisku wystepuje fraza ski
SELECT 
    *
FROM
    employees
WHERE
    lastName LIKE '%ski%'; -- sprawdza czy nazwisko ma w sobie fraze ski w dowolnym miejscu



-- podpunkt a.2) znajdz pracownikow ktorych nazwisko nie zaczyna sie od 'ab' (wielkosc liter bez znaczenia)
SELECT 
    *
FROM
    employees
WHERE
    lastName NOT LIKE 'ab%'; -- mamy dwa specjalne znaki do wyrazen regularnych '_' oraz '%', domyslnie mysql ignoruje wielkosc znakow przy porownywaniu literalow
    
    
    
-- podpunkt a.3)znajdz pracownikow ktorych nazwisko jest dluzsze niz N znakow
-- wartosc N zostala recznie wpisana w zapytanie 
SELECT 
    *
FROM
    employees
WHERE
    LENGTH(lastName) > 8;
    
    
    
-- podpunkt a.4) znajdz pracownikow w ktorych nazwisku na drugim miejscu wystepuje duza litera F
SELECT 
    *
FROM
    employees
WHERE
    BINARY lastName LIKE '_F%'; -- dodanie slowa kluczowego BINARY powoduje porownywanie stringow z uwzglednieniem wielkosci znakow 



-- podpunkt b) znajdz pracownikow w dziale X
-- dzial X zostal recznie wpisany poprzez jego nazwe w zapytaniu, nie trzeba dolaczac tabeli departments, mozna by filtrowac po kluczu departmentId w samej tabeli employees
SELECT 
    *
FROM
    employees
        INNER JOIN
    departments ON employees.departmentId = departments.id
WHERE
    departments.departmentName = 'it';



-- podpunkt c) znajdz projekty w ktorych zatrudniony byl pracownik z peselem X
-- pesel X zostal wpisany recznie w zapytanie
SELECT-- distint jest po to zeby pare razy nie wyswietlac jednej nazwy, mozna uzyskac ten sam efekt przez group by
     DISTINCT projects.projectName AS 'Nazwa projektu'
FROM
    employees
        LEFT JOIN
    employee_project_association ON employees.pesel = employee_project_association.employeePesel
        LEFT JOIN
    projects ON employee_project_association.projectId = projects.id
WHERE
    employees.pesel = '85101067890';



-- podpunkt d) policz w ilu projektach aktualnie zatrudniony jest pracownik X
-- w zapytaniu pracownik jest identyfikowany przez jego klucz(pesel) wpisany w zapytanie na sztywno
SELECT 
    employees.pesel AS Pesel,
    employees.firstName AS Imie,
    employees.lastName AS Nazwisko,
    COUNT(*) AS 'ilość projektów w których aktualnie zatrudniony jest pracownik'
FROM
    employees
        INNER JOIN
    employee_project_association ON employees.pesel = employee_project_association.employeePesel
WHERE
    (CURRENT_TIME() < employee_project_association.endDate
        OR employee_project_association.endDate IS NULL) -- sprawdzenie czy projekt jest aktualny dla pracownika
        AND employees.pesel = '85101067890';


-- podpunkt e) policz w ilu projektach w zeszlym roku zatrudniony byl pracownik X na stanowisku PL
-- pracownik(pesel) oraz stanowisko 'pl' wpisane sa sztywno w zapytanie
SELECT 
    employees.pesel AS 'pesel pracownika',
    employees.firstName As 'Imie',
    employees.lastName as 'Nazwisko',
    COUNT(employee_project_association.workType) AS 'ilość projektów z zeszłego roku w którym pracownik był zatrudniony na stanowisku PL'
FROM
    employees
        INNER JOIN
    employee_project_association ON employees.pesel = employee_project_association.employeePesel
WHERE
    (YEAR(CURRENT_DATE()) - 1 >= YEAR(employee_project_association.startDate)
        AND (YEAR(CURRENT_DATE()) - 1 <= YEAR(employee_project_association.endDate)
        || employee_project_association.endDate IS NULL)) -- filtrowanie dla projektow ktore trwaly w zeszlym roku
        AND employee_project_association.workType = 'pl' -- filtrowanie wg stanowisk
        AND employees.pesel = '79090953124' -- filtrowanie dla danego pracownika
group by employees.pesel, employees.firstName, employees.lastName; -- to samo zadanie przechodzi bez group by, sam count wystarczy(chyba w oraclu by to nie przeszlo ;) )

-- podpunkt f) wyszukaj zewnetrzne projekty
SELECT 
    *
FROM
    projects
WHERE
    projects.projectType = 'external';




-- podpunkt g) znajdz pracowników z działu X którzy pełnili w jakimś projekcie przynajmniej 2 funkcje 
-- (dzieki DISTINCT przy zliczaniu w having by mamy chronienie sie przed tym ze pracownik dwa razy byl zatrudniony na tej samej posadzie w tym samym projekcie)
-- dzial X zostal wpisany na sztywno w zapytaniu w klauzuli where(identyfikowany przez id)
SELECT 
    employees.firstName AS 'Imie',
    employees.lastName AS 'nazwisko',
    departments.departmentName as 'nazwa departamentu',
    employee_project_association.projectId AS 'id projektu',
    COUNT(employee_project_association.workType) AS 'liczba sprawowanych funkcji'
FROM
    employees
        INNER JOIN
    departments ON employees.departmentId = departments.id
        INNER JOIN
    employee_project_association ON employee_project_association.employeePesel = employees.pesel
WHERE departmentId = 1
GROUP BY employees.firstName , employees.lastName , employee_project_association.projectId
HAVING (COUNT(DISTINCT employee_project_association.workType) >= 2)
ORDER BY employees.firstName , employees.lastName , employee_project_association.projectId;



-- podpunkt h)  znajdz pracowników którzy pełnili w jakimś projekcie funkcje TCD i DEV
-- czyli mozemy zmodyfikowac zapytanie z poprzedniego punktu przez dodanie klauzuli where ktora filtruje zeby zostaly tabele w ktorych jest tylko tcd lub dev
-- nastepnie robimy grupowanie i i wyswietlamy tylko tych ktorzy mieli przypisane dwie rozne funkcje (having by)
SELECT 
    employees.firstName AS 'Imie',
    employees.lastName AS 'nazwisko',
    employee_project_association.projectId AS 'id projektu'
FROM
    employees
        INNER JOIN
    employee_project_association ON employee_project_association.employeePesel = employees.pesel
WHERE
    employee_project_association.workType IN ('TCD' , 'DEV')
GROUP BY employees.firstName , employees.lastName , employee_project_association.projectId
HAVING (COUNT(DISTINCT employee_project_association.workType) = 2)
ORDER BY employees.firstName , employees.lastName , employee_project_association.projectId;



-- podpunkt i) wyszukaj projekt w którym pracownik miał najwyższą dniówkę (ze wszystkich projektów w systemie)
SELECT 
    projects.projectName as 'nazwa projektu',
    concat(concat(employees.firstName, ' '), employees.lastName) as 'pracownik',
    employee_project_association.dailySalary as 'dzienna pensja'
FROM
    employees
        INNER JOIN
    employee_project_association ON employee_project_association.employeePesel = employees.pesel
		INNER JOIN 
	projects on projects.id = employee_project_association.projectId
ORDER BY employee_project_association.dailySalary DESC
LIMIT 1;



-- podpunkt i.1) wyszukaj najlepiej zarabiającego aktualnie pracownika (chodzi o sumaryczną wartość dniówek danego pracownika ze wszystkich projektów, do których jest aktualnie przypisany)
SELECT 
    employees.firstName as 'Imie',
    employees.lastName as 'Nazwisko',
    SUM(employee_project_association.dailySalary) as 'sumaryczna dzienna stawka'
FROM
    employees
        INNER JOIN
    employee_project_association ON employees.pesel = employee_project_association.employeePesel
WHERE
    (CURRENT_TIME() < employee_project_association.endDate
        OR employee_project_association.endDate IS NULL) -- sprawdzenie czy projekt jest aktualny
GROUP BY employees.pesel, employees.firstName , employees.lastName
ORDER BY SUM(employee_project_association.dailySalary) DESC , employees.firstName ASC , employees.lastName ASC
LIMIT 1;


-- podpunkt j) znajdz pracownikow, ktorzy pracowali w projekcie X pomiedzy data Y i Z
-- dane do zadania podane jako zmienne uzytkownika, nie sa wpisane recznie w zapytanie
set @date1 = '2014-01-01'; -- pierwsza data w przedziale
set @date2 = '2016-01-01'; -- druga data w przedziale
set @projectX = 2; 	-- id projektu X dla ktorego sprawdzamy
SELECT 
    *
FROM
    employees
        INNER JOIN
    employee_project_association ON employee_project_association.employeePesel = employees.pesel
WHERE
    employee_project_association.projectId = @projectX
        AND (
			employee_project_association.startDate BETWEEN @date1 AND @date2 
			OR employee_project_association.endDate BETWEEN @date1 AND @date2
			OR (employee_project_association.startDate < @date1 AND employee_project_association.endDate IS NULL) -- dodane poniewaz jesli nie mamy podanego terminu zakonczenia to trzeba dokonac takiego sprawdzenia
        );

-- podpunkt k) znajdz pracownikow nie przypisanych do żadnego z działów
SELECT 
    *
FROM
    employees
WHERE
    employees.departmentId IS NULL;



-- podpunkt l) znajdz pracownikow zarabaiajacych aktualnie w jednym z projektow (dziennie) wiecej niz X
-- prog zarobkow jest podany jako zmienna uzytkownika, a nie wpisana recznie w zapytanie
set @oneProjectSalaryX = 450;
SELECT 
    *
FROM
    employees
        INNER JOIN
    employee_project_association ON employee_project_association.employeePesel = employees.pesel
WHERE
    (CURRENT_TIME() < employee_project_association.endDate
        OR employee_project_association.endDate IS NULL) -- sprawdzenie aktualnosci projektu
        AND employee_project_association.dailySalary > @oneProjectSalaryX -- sprawdzenie czy dzienna wyplata w projekcie jest wieksza niz podana
ORDER BY employee_project_association.dailySalary ASC;


-- podpunkt m) znajdz pracownikow zarabaiajacych aktualnie (dziennie) wiecej niz X
-- prog sumy dziennych zarobkow z roznych projektow jest podany jako zmienna uzytkownika a nie wpisana recznie w zapytanie
set @oneDaySumSalaryX= 700;
SELECT 
    employees.firstName as 'Imie',
    employees.lastName as 'Nazwisko',
    SUM(employee_project_association.dailySalary) as 'suma dziennych stawek'
FROM
    employees
        INNER JOIN
    employee_project_association ON employee_project_association.employeePesel = employees.pesel
WHERE
    (CURRENT_TIME() < employee_project_association.endDate
        OR employee_project_association.endDate IS NULL) -- odfiltrowanie wylacznie aktualnych projektow
GROUP BY employees.pesel, employees.firstName , employees.lastName
HAVING (SUM(employee_project_association.dailySalary) > @oneDaySumSalaryX)
ORDER BY SUM(employee_project_association.dailySalary) ASC , employees.firstName ASC , employees.lastName ASC;


-- podpunkt n) zaktualizuj nazwisko wybranego pracownika
-- pierwsze sluzy do pokazania danych pracownika o danym peselu, druga instrukcja zmienia nazwisko wybranego pracownika
SELECT 
    *
FROM
    employees
WHERE
    employees.pesel = '01234567890';

UPDATE employees -- aktualizuje nazwisko wybranego pracownika
SET 
    employees.lastName = 'zmienione' -- tutal podajemy nowa wartosc
WHERE
    employees.pesel = '01234567890'; -- tu filtrujemy wiersze dla ktorych dokonujemy zmiany




-- podpunkt o) rozważ, w jaki sposób najlepiej kasować dane pracownika z systemu. zaproponuj zapytanie kasujące dane wybranego pracownika 

 
-- 1) ponizej jest standardowy sposob usuwania danych z tabeli, z tym ze u nas to nie dziala poniewaz istnienie w definicji innych tabel klucza obcego na tabele departments blokuje to, istnieja dane powiazane z tym co chcemy usunac
-- delete from departments where departments.id = 1;

-- 2) na tabele ponizej z ktorej usuwamy zadna inna tabela nie posiada klucza obcego dlatego mozemy w prosty sposob usunac dane ponizszym poleceniem
-- delete from employee_project_association where id = 1;

-- 3) ponizsze przez klucz w employee_project_association pokazujacy na ta tabele nie da usunac ponizszym poleceniem
-- delete from projects where projects.id = 1; 

-- 4) zeby usunac cos powiazanego z czyms innym z tabel nalezy najpierw usunac powiazane produkty(bez innych powiazan) a dopiero nastepnie to co chcemy usunac
--    czyli pare roznych intrukcji delete
-- 5) w internecie znalazlem sposob na automatyzacje usuwania poprzez zastosowanie triggerow
-- http://stackoverflow.com/questions/25819719/sql-delete-with-foreign-key-constraint
-- http://www.mysqltutorial.org/mysql-on-delete-cascade/

-- 6 mozna w definicji klucza obcego dac dodatkowe contraint ON DELETE CASCADE wtedy powinno usuwac sprawnie bez problemow kaskadowo
    delete from projects where projects.id = 1; 
    
    select * from employee_project_association where employee_project_association.projectId = 2;

-- podpunkt o.1) zaktualizuj nazwę projektu w systemie
-- ponizszy select wyswietla wszystkie projekty w systemie
SELECT 
    *
FROM
    projects;

-- ponizsze polecenie aktualizuje nazwe projektu w systemie( dobrze ze nazwa nie jest kluczem glownym :) )
UPDATE projects 
SET 
    projects.projectName = 'JavaStarterKit' -- nowa wartosc w kolumnie
WHERE
    projects.id = 1; -- w kolumnie spelniajacej ten warunek
