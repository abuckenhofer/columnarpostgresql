# columnarpostgresql
Dockerfile for building and running PostgreSQL with columnstore CStore extension.

A columnar store can be used for analytical queries. Such stores organize data physically in columns instead of rows. CStore_fdw (see https://github.com/citusdata/cstore_fdw) is a columnar extension for PostgreSQL.

## How to run the container
First pull and run the container from a command line. The directory /var/lib/postgresql/data contains the data and the PostgreSQL config files. Port 5432 is exposed and a password for the postgres database user can be set.
```
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=setpassword -v /data/postgres:/var/lib/postgresql/data --name columnarpostgresql abuckenhofer/columnarpostgresql:latest
```
Next, execute an interactive bash shell in the container
```
docker exec -it columnarpostgresql bash
```
Finally, start PostgreSQL command line
```
psql -U postgres
```

## How to create a columnar table
The following code creates a columnar test table.
```
-- Load extension
CREATE EXTENSION cstore_fdw;

-- create server object to access an external data resource
CREATE SERVER cstore_server FOREIGN DATA WRAPPER cstore_fdw;

-- create columnar table
CREATE FOREIGN TABLE sales_fact
(
    fk_customer_id INTEGER
  , fk_product_id INTEGER
  , fk_salesdate DATE
  , quantity INTEGER
  , price NUMERIC(5,2)
  , discount NUMERIC(5,2)
)
SERVER cstore_server
OPTIONS(compression 'pglz');
```

For more information see my article: ["PostgreSQL columnar extension cstore_fdw"](https://www.buckenhofer.com/2021/01/postgresql-columnar-extension-cstore_fdw/)

## Changeset

V 1.2
* sample files added
* Bugfix: postgresql-server-dev-12 instead of postgresql-server-dev-all

V 1.1
* supports PostgreSQL 12.4

V 1.0 
* Initial version with cstore_fdw integration
* supports PostgreSQL 11.5
