CREATE EXTENSION postgres_fdw;

CREATE SERVER mondial_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'mondial', port '5432');

CREATE USER MAPPING FOR postgres
SERVER mondial_server
OPTIONS (user 'postgres', password 'root');

--limit only to the necessary tables, because of custom type that exists in mondial(geocoord)
--we either have to create a custom type in BigData_Dataset or import only necessary tables
IMPORT FOREIGN SCHEMA public LIMIT TO (country, isMember, organization)
FROM SERVER mondial_server
INTO public;

