-- TRESC: naucz się tworzyć nowych użytkowników użytkowników w bazie danych oraz przyznawać (GRANT) oraz odbierać (REVOKE) uprawnienia.

-- do tworzenia uzytkowników słuzy polecenie (mozna w nim przyznac od razu uprawnienia do tabel)
-- 	  CREATE USER [IF NOT EXISTS]
--    user [auth_option] [, user [auth_option]] ...
--    [REQUIRE {NONE | tls_option [[AND] tls_option] ...}]
--    [WITH resource_option [resource_option] ...]
--    [password_option | lock_option] ...

-- do przyznawania uprawnien sluzy polecenie
-- GRANT [type of permission] ON [database name].[table name] TO ‘[username]’@'localhost’;
-- do obierania uprawnien sluzy polecenie
-- REVOKE [type of permission] ON [database name].[table name] FROM ‘[username]’@‘localhost’;
-- usuwanie uzytkownika
-- DROP USER ‘demo’@‘localhost’;
-- odswieza dane o uprawnieniach
-- FLUSH PRIVILEGES;
-- logowanie sie
-- mysql -u [username]-p

CREATE USER IF NOT EXISTS 'user_ro' IDENTIFIED BY 'user_ro';
CREATE USER IF NOT EXISTS 'arni' IDENTIFIED BY 'password';
CREATE USER IF NOT EXISTS 'romek' IDENTIFIED BY 'password';
CREATE USER IF NOT EXISTS 'user_rw_projekt' IDENTIFIED BY 'user_rw_projekt';

grant all Privileges On starterkit.projects TO 'user_rw_projekt';  -- daje wszystkie uprawnienia w schemacie starterkit do tabeli projects
grant select on starterKit.* TO 'user_ro'; -- daje mozliwosc czytania wszystkich tabel z schematu starterKit

flush privileges;

