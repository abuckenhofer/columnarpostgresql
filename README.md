# columnarpostgresql
Repository containing a Dockerfile: PostgreSQL with columnstore cstore extension for analytical workloads.

A columnar store is used for analytical queries. CStore_fdw is a columnar extension for PostgreSQL. The repository contains a Dockerfile to build a PostgreSQL containing the extension. 

## How to run the container

First pull and run the container from a command line
```
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=postgres -v /data/postgres:/var/lib/postgresql/data --name columnarpostgresql abuckenhofer/columnarpostgresql
```
Next, execute an interactive bash shell in the container
```
docker exec -it columnarpostgresql bash
```
Finally, start PostgreSQL command line
```
pgsql -U postgres
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
