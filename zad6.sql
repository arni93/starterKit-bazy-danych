USE forum;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

-- 1) policz wszystkich aktywnych uzytkownikow forum
-- aktywni uzytkownicy w tym podpunkcie to ci ktorzy odwiedzili strone w ciagu ostatniego roku 
SELECT 
    COUNT(*) AS 'licza aktywynych uzytkownikow'
FROM
    users
WHERE
    DATEDIFF(CURRENT_DATE(),
            FROM_UNIXTIME(users.last_visit)) < 365;


-- 2) znajdz najbardziej aktywnego uzytkownika forum torrepublic w roku 2015, 2014 i wczesniej. Sam zdefiniuj kryterium aktywnosci
-- najbardziej aktywny uzytkownik to ten ktory w danym roku mial najwieksza ilosc postow
-- mozna to rozbic na view po czym po zapytaniu je usuwac
SELECT 
    postsQuantityPerEachUserInEachYear.year as 'rok',
    postsQuantityPerEachUserInEachYear.username as 'uzytkownik',
    postsQuantityPerEachUserInEachYear.postQuantity as 'liczba postow'
FROM
    (SELECT 
        YEAR(FROM_UNIXTIME(posts.posted)) AS year,
            users.username AS username,
            COUNT(posts.id) AS postQuantity
    FROM
        users
    INNER JOIN posts ON users.id = posts.poster_id
    WHERE
        username <> 'guest'
    GROUP BY YEAR(FROM_UNIXTIME(posts.posted)) , users.id , users.username
    ORDER BY COUNT(posts.id) DESC) AS postsQuantityPerEachUserInEachYear
        INNER JOIN
    (SELECT 
        results.year AS year,
            MAX(results.postQuantity) AS maxPostQuantity
    FROM
        (SELECT 
        YEAR(FROM_UNIXTIME(posts.posted)) AS year,
            users.id AS userId,
            COUNT(posts.id) AS postQuantity
    FROM
        users
    INNER JOIN posts ON users.id = posts.poster_id
    WHERE
        username <> 'guest'
    GROUP BY YEAR(FROM_UNIXTIME(posts.posted)) , users.id) results
    GROUP BY results.year) AS maxPostPerUserInEachYear ON maxPostPerUserInEachYear.maxPostQuantity = postsQuantityPerEachUserInEachYear.postQuantity;




-- 3) znajdz pieciu uzytkownikow, ktorych suma dlugosci wszystkich komentarzy jest najwieksza
SELECT 
    users.username as 'uzytkownik',
    SUM(LENGTH(posts.message)) as 'dlugosc wszystkich komentarzy'
FROM
    users
        INNER JOIN
    posts ON users.id = posts.poster_id
WHERE
    users.username <> 'guest'
GROUP BY users.id , users.username
ORDER BY SUM(LENGTH(posts.message)) DESC
LIMIT 5;



-- 4) znajdz uzytkownika ktory nigdy nie napisal zadnego komentarza
SELECT 
    distinct users.username as 'uzytkownik'
FROM
    users
        LEFT JOIN
    posts ON users.id = posts.poster_id
WHERE
    posts.id is null;
    
    
    
-- 5) znajdz uzytkownikow ktorzy oferowali rzeczy lub uslugi niezgodne z prawem
SELECT 
    topics.poster as 'uzytkownik', 
    topics.subject as 'temat'
FROM
    topics
WHERE
    LOWER(topics.subject) LIKE '%sprz%haszysz%'
        OR LOWER(topics.subject) LIKE ('%sprz%kont%')
        OR LOWER(topics.subject) LIKE ('%sprz%koka%')
        OR LOWER(topics.subject) LIKE ('%sprz%amfetam%')
        OR LOWER(topics.subject) LIKE ('%sprz%extasy%')
        OR LOWER(topics.subject) LIKE ('%sprz%kradzion%');



-- 6) z jakiej poczty korzystaja uzytkownicy forum torepublic? policz rozne serwery z ktorych korzystaja i posortuj je malejaco
SELECT 
    SUBSTRING(users.email FROM POSITION('@' IN users.email) + 1) as 'serwery email',
    COUNT(users.email) as 'liczba uzytkujacych uzytkownikow'
FROM
    users
GROUP BY SUBSTRING(users.email FROM POSITION('@' IN users.email) + 1)
ORDER BY COUNT(users.email) DESC;

