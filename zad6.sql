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

SELECT 
    postsQuantityPerEachUserInEachYear.year,
    postsQuantityPerEachUserInEachYear.username,
    postsQuantityPerEachUserInEachYear.postQuantity
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



