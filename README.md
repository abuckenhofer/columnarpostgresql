# columnarpostgresql
Repository containg a Dockerfile: PostgreSQL with columnstore cstore extension for analytical workloads

A columnar store is used for analytical queries. CStore_fdw is a columnar extension for PostgreSQL. The repository contains a Dockerfile to build a PostgreSQL containing the extension. 

Columnar table example

 

## A simple test using the extension.

-- load extension
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
